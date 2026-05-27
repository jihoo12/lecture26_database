CREATE OR REPLACE PROCEDURE cancel_order (
    p_order_id IN orders.order_id%TYPE
)
IS
    v_status orders.status%TYPE;
BEGIN
    -- 1. 주문 상태 조회
    SELECT status INTO v_status
    FROM orders
    WHERE order_id = p_order_id;

    -- 2. 이미 취소된 주문인지 체크
    IF v_status = 'CANCELLED' THEN
        DBMS_OUTPUT.PUT_LINE('이미 취소된 주문입니다.');
        RETURN;
    END IF;

    -- 3. 배송 완료된 주문인지 체크 (위치 조정 및 세미콜론 확인)
    IF v_status = 'DELIVERED' THEN
        DBMS_OUTPUT.PUT_LINE('배송 완료된 주문은 취소할 수 없습니다.');
        RETURN;
    END IF;

    -- 4. 안내 메시지 출력 (끝에 세미콜론 ';' 필수!)
    DBMS_OUTPUT.PUT_LINE('주문 ' || p_order_id || ' 취소 완료 및 재고 복구 처리 중...');

    -- 5. 주문 상태 변경
    UPDATE orders
    SET status = 'CANCELLED', cancel_date = SYSDATE
    WHERE order_id = p_order_id;

    -- 6. 해당 주문 건의 상품 재고 복구
    UPDATE inventory i
    SET i.stock = i.stock + (
        SELECT od.quantity FROM order_detail od
        WHERE od.order_id = p_order_id AND od.product_id = i.product_id
    )
    WHERE i.product_id IN (
        SELECT product_id FROM order_detail WHERE order_id = p_order_id
    );

    COMMIT;
END;
/
SHOW ERRORS;

EXIT;