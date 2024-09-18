////////////////////////
// receipt
////////////////////////

document.addEventListener("DOMContentLoaded", () => {
    generateReceipt();
    document.getElementById("receipt_download_pdf").addEventListener("click", downloadPDF);
});

function generateReceipt() {
    const urlParams = new URLSearchParams(window.location.search);
    const ticket = parseFloat(urlParams.get('ticket'));
    const quantity = parseInt(urlParams.get('quantity'));
    const coupon = urlParams.get('coupon');
    const ticket_price = ticket == 1 ? 200 : 510;
    
    const discount_percent = CouponCheck(coupon);
    const subtotal = parseFloat((quantity * ticket_price).toFixed(2));
    const discount = discount_percent > 1.00 ? parseFloat((subtotal-discount_percent).toFixed(2)) : parseFloat((subtotal * (1.00-discount_percent)).toFixed(2))
    const taxRate = 0.13;
    const tax = parseFloat(((subtotal - discount) * taxRate).toFixed(2));
    const finalPrice = parseFloat((subtotal - discount + tax).toFixed(2));
    const qrData = generateRandomString(20);

    
    const receiptContainer = document.getElementById("Receipt_Block1").innerHTML = 
    `
        <br><br>
        <h1 style="font-family: 'Fascinate Inline', system-ui; font-size: 70px; margin: 20px;">Order Summary</h1>
        <p class="Receipt_p">Number of tickets: ${quantity}</p>
        <p class="Receipt_p">Price per ticket: $${ticket_price.toFixed(2)}</p>
        <p class="Receipt_p">Subtotal: $${subtotal.toFixed(2)}</p>
        <p class="Receipt_p">Coupon Discount: -$${discount.toFixed(2)}</p>
        <p class="Receipt_p">Tax: $${tax.toFixed(2)}</p>
        <p class="Receipt_p">Final Price: $${finalPrice.toFixed(2)}</p>

        <br><br><br>
        <h2 style="font-family: 'Fascinate Inline', system-ui; font-size: 70px; margin: 20px;">Ticket QR Code</h2>
        <div id="receipt_qrcode"></div>
        <br><br>
        <button class="custom_button" id="receipt_download_pdf">Download PDF</button>
        <br><br>
    `;

    // Generate QR code
    new QRCode(document.getElementById("receipt_qrcode"), {
        text: qrData,
        width: 128,
        height: 128,
    });

    // Store data for PDF generation
    window.receiptData = {
        quantity,
        ticketPrice: ticket_price.toFixed(2),
        subtotal: subtotal.toFixed(2),
        discount: discount.toFixed(2),
        tax: tax.toFixed(2),
        finalPrice: finalPrice.toFixed(2),
        qrData,
    };
}

function generateRandomString(length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()';
    let result = '';
    const charactersLength = characters.length;
    for (let i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

async function downloadPDF() {
    const { jsPDF } = window.jspdf;
    const { quantity, ticketPrice, subtotal, discount, tax, finalPrice, qrData, } = window.receiptData;

    const doc = new jsPDF();

    // Add Receipt Title
    doc.setFontSize(18);
    doc.text("Order Summary", 105, 20, null, null, "center");

    // Add Receipt Details
    doc.setFontSize(12);
    let yPosition = 30;
    const lineHeight = 10;

    doc.text(`Number of tickets: ${quantity}`, 20, yPosition);
    yPosition += lineHeight;
    doc.text(`Price per ticket: $${ticketPrice}`, 20, yPosition);
    yPosition += lineHeight;
    doc.text(`Subtotal: $${subtotal}`, 20, yPosition);
    yPosition += lineHeight;
    doc.text(`Coupon Discount: - $${discount}`, 20, yPosition);
    yPosition += lineHeight;
    doc.text(`Tax: $${tax}`, 20, yPosition);
    yPosition += lineHeight;
    doc.setFontSize(18);
    doc.text(`Final Price: $${finalPrice}`, 20, yPosition);

    doc.text("Ticket QR Code", 105, 110, null, null, "center");
    doc.setFontSize(12);

    // Add QR Code
    const qrCanvas = document.querySelector("#receipt_qrcode canvas");
    const qrImageData = qrCanvas.toDataURL("image/png");
    doc.addImage(qrImageData, "PNG", 68, 130, 75, 75);

    doc.save("receipt.pdf");
}

