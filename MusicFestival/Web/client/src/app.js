
document.addEventListener("DOMContentLoaded", () =>{

})

function ClacTotal(TicketType, Quantity, Coupon){
    let HST = 1.13;
    let Total = 0.00;
    let discount = 1;

    if (TicketType == 1)
        Total = parseFloat((200 * Quantity).toFixed(2));
    else if (TicketType == 2)
        Total = parseFloat((510 * Quantity).toFixed(2));

    if(Coupon != "")
    {
        discount = CouponCheck(Coupon);
        
        if(discount > 1)
            Total = parseFloat((Total-discount).toFixed(2));
        else
            Total = parseFloat((Total*discount).toFixed(2));
    }
    Total = parseFloat((Total * HST).toFixed(2));

    return Total;
}

function CouponCheck(CouponCode){
    let discount = 1.00; // 1 = 0% off

    if(CouponCode == "TEST")
        discount = 0.85; // discount(%)
    else if(CouponCode == "TEST2")
        discount = 100.00; //discount(Cur)

    return discount;
}



