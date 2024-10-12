document.addEventListener("DOMContentLoaded", () =>{
    
})

document.querySelector("#BtnCalculate").addEventListener("click", () => {
    const on_peak_fee = 0.132;
    const off_peak_fee = 0.065;
    const HST = 0.13;
    const BC_rebate = 0.08;

    // Filter
    if(isNaN(document.getElementById("InOnPeak").value) || document.getElementById("InOnPeak").value === "" || isNaN(document.getElementById("InOffPeak").value) || document.getElementById("InOffPeak").value === "")
        alert("Input the number at on-peak and off-peak hours");
    if(document.getElementById("InProvince").value != "British Columbia" && document.getElementById("InProvince").value != "Ontario")
        alert("Input the British Columbia or Ontario at Province of residence column")
    
    // Declare Parameter
    const on_peak_hours = document.getElementById("InOnPeak").value;
    const off_peak_hours = document.getElementById("InOffPeak").value;
    const on_peak_usage = parseFloat((on_peak_hours * on_peak_fee).toFixed(2));
    const off_peak_usage = parseFloat((off_peak_hours * off_peak_fee).toFixed(2));

    const total_con_charge = parseFloat((on_peak_usage + off_peak_usage).toFixed(2));
    const sales_tax = parseFloat((total_con_charge * HST).toFixed(2));
    const rebate = document.getElementById("InProvince").value == "British Columbia" ? parseFloat((total_con_charge * BC_rebate).toFixed(2)) : 0;
    const final_total = parseFloat((total_con_charge + sales_tax - rebate).toFixed(2));

    // Output to console
    console.log("On Peak Charges: $"+on_peak_usage);
    console.log("Off Peak Consumption: $"+off_peak_usage);
    console.log("Total Consumption Charges: $"+total_con_charge);
    console.log("Sales Tax: $"+sales_tax);
    console.log("Provincial Rebate: $"+rebate);
    console.log("YOU MUST PAY: $"+final_total);

    // Output to HTML
    const outputBlock = document.querySelector('.BtnOutput');
    outputBlock.style.display = "block";

    document.getElementById("BtnBlock1_Fee1").textContent = "$" + on_peak_usage;
    document.getElementById("BtnBlock1_kwH1").textContent = document.getElementById("InOnPeak").value + " kwH @ $" + on_peak_fee + "/hr";
    document.getElementById("BtnBlock1_Fee2").textContent = "$" + off_peak_usage;
    document.getElementById("BtnBlock1_kwH2").textContent = document.getElementById("InOffPeak").value + " kwH @ $" + off_peak_fee + "/hr";

    document.getElementById("BtnBlock2_Total").textContent = "Total Consumption Charges: $" + total_con_charge;
    document.getElementById("BtnBlock2_Tax").textContent = "Sales Tax(13%): $" + sales_tax;
    document.getElementById("BtnBlock2_Charge").textContent = "Provincial Rebate: -$" + rebate;

    document.getElementById("BtnBlock3_Fee").textContent = "$" + final_total;

})