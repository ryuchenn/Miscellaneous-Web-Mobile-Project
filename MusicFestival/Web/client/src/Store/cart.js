
////////////////////////
// Cart
////////////////////////
let Global_Total = 0.00;
let selectedTicket = document.querySelector('input[name="ticket"]:checked'); 
let selectedQuantity = document.getElementById('CartQuantity').value;

document.querySelector("#BtnCartBuy").addEventListener("click", (event) => {
    event.preventDefault(); // !! Prevent webpage reload !!
    
    selectedTicket = document.querySelector('input[name="ticket"]:checked'); 
    selectedQuantity = document.getElementById('CartQuantity').value;

    if (!selectedTicket){
        alert('No ticket type selected.'); 
        return;
    }
    
    // Goto Next Page
    const targetUrl = `purchase.html?ticket=${encodeURIComponent(parseFloat(selectedTicket.value))}&quantity=${encodeURIComponent(parseFloat(selectedQuantity))}&coupon=${encodeURIComponent(document.getElementById("InCoupon").value)}`;
    window.location.href = targetUrl;
})

document.querySelectorAll("#BtnTicket").forEach((element) => {
    element.addEventListener("click", () => {
        Refresh_Data()
    });
})

document.querySelector("#CartQuantity").addEventListener("change", () => {
    Refresh_Data()
})

document.getElementById("InCoupon").addEventListener('keyup', () => {
    Refresh_Data()
});

function Refresh_Data(){
    let selectedTicket = document.querySelector('input[name="ticket"]:checked'); 
    let selectedQuantity = document.getElementById('CartQuantity').value;

    if (selectedTicket){
        Total = ClacTotal(parseFloat(selectedTicket.value), parseFloat(selectedQuantity), document.getElementById("InCoupon").value);
        document.getElementById("Cart_Total").textContent = "Total(+Tax): $" + Total.toFixed(2) + " CAD";
    }
}