
////////////////////////
// Purchase
////////////////////////
let receipt = []

document.addEventListener("DOMContentLoaded", () =>{
    GetData();

    //Pay Button
    document.getElementById("Purchase_Pay").addEventListener("click", (event)=>{
        event.preventDefault(); // !! Prevent webpage reload !!
        BtnPay();
    })
})

function GetData(){
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const ticket = urlParams.get('ticket');
    const quantity = urlParams.get('quantity');
    const coupon = urlParams.get('coupon');

    let TmpTotal = ClacTotal(parseFloat(ticket), parseFloat(quantity), coupon);
    let USDCTotal = parseFloat((TmpTotal*0.75).toFixed(2))
    let BTCTotal = parseFloat((USDCTotal/60000).toFixed(6))
    
    receipt.push({ticket: ticket, quantity: quantity, coupon: coupon, Total: TmpTotal, USDC: USDCTotal, BTC: BTCTotal})
    // alert("ticket: "+ ticket + quantity+ coupon+ ",Total: " +TmpTotal + " , USDC:" + USDCTotal + " , Bitcoin: " + BTCTotal)

    document.getElementById("Purchase_Total").textContent = "Total(+Tax): $" + TmpTotal.toFixed(2) + " CAD ≈ $" + USDCTotal.toFixed(2) + " USDC ≈ $" + BTCTotal.toFixed(6) + " BTC";
}

function BtnPay(){
    let selectedPay = document.getElementById('Purchase_PayOptions').value; 

    if(document.getElementById('InEmail').value == ""){
        alert("Fill Your E-Mail Address")
        return;
    }
    if(selectedPay == 0){
        alert("Choose Your Pay Options")
        return;
    }

    if(selectedPay == 1){
        if(document.getElementById('InCardNumber').value == ""){
            alert("Fill Your Card Number")
            return;
        }
        if(parseInt(document.getElementById('InCardNumber').value.length) != 6){
            alert("You Should Provide 6 Digit Number Credit Card Number")
            return;
        }
        if(document.getElementById('InCardPIN').value == ""){
            alert("Fill Your Card PIN")
            return;
        }
        

        if(receipt.length>0){
            const targetUrl = `receipt.html?ticket=${encodeURIComponent(parseFloat(receipt[0].ticket))}&quantity=${encodeURIComponent(parseFloat(receipt[0].quantity))}&coupon=${encodeURIComponent(receipt[0].coupon)}&Total=${encodeURIComponent(parseFloat(receipt[0].Total))}&USDC=${encodeURIComponent(parseFloat(receipt[0].USDC))}&BTC=${encodeURIComponent(parseFloat(receipt[0].BTC))}`;
            window.location.href = targetUrl;
        }
    }
    else if (selectedPay == 2){
        if(document.getElementById('InCryptoAddress').value == ""){
            alert("Fill Your Crypto Address");
            return;
        }
        
        if(receipt.length>0){
            const targetUrl = `receipt.html?ticket=${encodeURIComponent(parseFloat(receipt[0].ticket))}&quantity=${encodeURIComponent(parseFloat(receipt[0].quantity))}&coupon=${encodeURIComponent(receipt[0].coupon)}&Total=${encodeURIComponent(parseFloat(receipt[0].Total))}&USDC=${encodeURIComponent(parseFloat(receipt[0].USDC))}&BTC=${encodeURIComponent(parseFloat(receipt[0].BTC))}`;
            window.location.href = targetUrl;
        }
    }
}

document.querySelectorAll("#Purchase_PayOptions").forEach((element) => {
    element.addEventListener("change", () => {
        let selectedPay = document.getElementById('Purchase_PayOptions'); 
        
        if (selectedPay)
        {
            let tmpText = "";
            tmpText += "</div>";
            if (selectedPay.value == 1) //Credit
            {
                tmpText += 
                `
                <div>
                    <div>
                        <p class="Purchase_p" style="font-size: 35px;">Card Number</p>
                        <input class="input_field" id="InCardNumber" placeholder="Enter Your Card Number"></input>
                        <p class="Purchase_p" style="font-size: 35px;">PIN</p>
                        <input class="input_field" id="InCardPIN" placeholder="Enter Your PIN"></input>
                    </div>
                </div>
                `;
            }
            else if (selectedPay.value == 2) //Crypto
            {
                tmpText += 
                `
                <div>
                    <div id="Donate_Block1">
                        <div>
                            <p class="Purchase_p">Bitcoin</p>
                            <img src="../../../../Common/Image/Other/Bitcoin.png"></img>
                            <p class="Purchase_p">Address:</p>
                            <p >bc1qygn4qmyyc65llln3csm63gxtgmwxfazy6sxd0e</p>
                        </div>
                        <div>
                            <p class="Purchase_p">(ERC20) USDC</p>
                            <img src="../../../../Common/Image/Other/ERC20_USDC.png"></img>
                            <p class="Purchase_p">Address:</p>
                            <br/>
                            <p >0x65bc0dE500d04A7340a557d987c27c51a952fbd5</p>
                        </div>
                        <div>
                            <p class="Purchase_p">(Polygon) USDC</p>
                            <img src="../../../../Common/Image/Other/Polygon_USDC.png"></img>
                            <p class="Purchase_p">Address:</p>
                            <p >0x65bc0dE500d04A7340a557d987c27c51a952fbd5</p>
                        </div>
                    </div>
                    <div>
                        <li class="Purchase_p" style="margin-top: 6%; font-size: 40px;">Channel & Crypto Address</li>
                        <p class="Purchase_p" style="font-size: 35px;">Provide your crypto currency address for payment verification.</p>
                        <select class="form_control" id="Purchase_Crypto_Channel" name="Purchase_Crypto_Channel">
                            <option value="Bitcoin" selected>Bitcoin</option> <!-- Default Setting -->
                            <option value="ERC20">(ERC20) USDC</option>
                            <option value="Polygon">(Polygon) USDC</option>
                        </select>
                        <input class="input_field" id="InCryptoAddress" placeholder="Enter Your Cryptocurrency Address"></input>

                    </div>

                </div>
                `;
            }
            tmpText += "</div>";
            document.getElementById("Purchase_Option").innerHTML = tmpText;
            
            // Change to "" when channel be changed
            document.querySelectorAll("#Purchase_Crypto_Channel").forEach((element) => {
                element.addEventListener("change", () => {
                    document.getElementById("InCryptoAddress").value = "";
                });
            });
        }
    });
})
