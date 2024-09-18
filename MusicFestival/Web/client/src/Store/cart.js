
////////////////////////
// Cart
////////////////////////
let Global_Total = 0.00;
document.querySelector("#BtnCartBuy").addEventListener("click", (event) => {
    event.preventDefault(); // !! Prevent webpage reload !!

    let selectedTicket = document.querySelector('input[name="ticket"]:checked'); 
    let selectedQuantity = document.getElementById('CartQuantity').value;
    if (!selectedTicket){
        alert('No ticket selected.'); 
        return;
    }
    
    const targetUrl = `purchase.html?ticket=${encodeURIComponent(parseFloat(selectedTicket.value))}&quantity=${encodeURIComponent(parseFloat(selectedQuantity))}&coupon=${encodeURIComponent(document.getElementById("InCoupon").value)}`;
    window.location.href = targetUrl;
})

document.querySelectorAll("#BtnTicket").forEach((element) => {
    element.addEventListener("click", () => {
        let selectedTicket = document.querySelector('input[name="ticket"]:checked'); 
        let selectedQuantity = document.getElementById('CartQuantity').value;
        
        if (selectedTicket)
        {
            Total = ClacTotal(parseFloat(selectedTicket.value), parseFloat(selectedQuantity), document.getElementById("InCoupon").value);
            document.getElementById("Cart_Total").textContent = "Total(+Tax): $" + Total.toFixed(2) + " CAD";
        }
    });
})

document.querySelector("#CartQuantity").addEventListener("change", () => {
    let selectedTicket = document.querySelector('input[name="ticket"]:checked'); 
    let selectedQuantity = document.getElementById('CartQuantity').value;
    
    if (selectedTicket)
    {
        Total = ClacTotal(parseFloat(selectedTicket.value), parseFloat(selectedQuantity), document.getElementById("InCoupon").value);
        document.getElementById("Cart_Total").textContent = "Total(+Tax): $" + Total.toFixed(2) + " CAD";
    }
})

document.getElementById("InCoupon").addEventListener('keyup', () => {
    let selectedTicket = document.querySelector('input[name="ticket"]:checked'); 
    let selectedQuantity = document.getElementById('CartQuantity').value;

    if (selectedTicket && document.getElementById("InCoupon").value != "")
    {
        Total = ClacTotal(parseFloat(selectedTicket.value), parseFloat(selectedQuantity), document.getElementById("InCoupon").value);
        document.getElementById("Cart_Total").textContent = "Total(+Tax): $" + Total.toFixed(2) + " CAD";
    }
    else 
    {
        Total = ClacTotal(parseFloat(selectedTicket.value), parseFloat(selectedQuantity), "");
        document.getElementById("Cart_Total").textContent = "Total(+Tax): $" + Total.toFixed(2) + " CAD";
    }
});
