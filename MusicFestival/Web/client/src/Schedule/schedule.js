
document.addEventListener("DOMContentLoaded", () =>{
    
    // document.querySelector("#test").textContent = "123";
    let musician = [];
    let tmpText = "";
    const basePath = getBasePath(0);
    const RootPath = getBasePath(1);
    musician.push({Name: "HONNE", Time: "Friday, 07:00 PM Sep 27, 2024", Genre: "R&B, Soul", Description: "HONNE consists of Andy Clutterbuck and James Hatcher. Their music often focuses on themes of love and relationships, attracting a large young audience with its intimate and straightforward expression."});
    musician.push({Name: "French Kiwi Juice", Time: "Friday, 08:00 PM Sep 27, 2024", Genre: "Soul, Jazz", Description: "FKJ, whose real name is Vincent Fenton, is a French musician and producer. He is proficient in multiple instruments, especially the keyboard and saxophone. His live performances are known for their creativity and multi-layered musical arrangements."});
    musician.push({Name: "NewJeans", Time: "Saturday, 07:00 PM Sep 28, 2024", Genre: "K-POP", Description: "New Jeans was formed in 2022 by ADOR, a label under HYBE in South Korea. The group quickly gained a large fan base with its unique music style and fashion sense, becoming a rising force in the Korean music scene"});
    musician.push({Name: "Taylor Swift", Time: "Saturday, 08:00 PM Sep 28, 2024", Genre: "POP, Country", Description: "Taylor Swift is an American singer-songwriter who has captivated millions of listeners worldwide with her personal lyrics and melodies. Her albums have repeatedly broken sales records and won numerous accolades, including multiple Grammy Awards."});
    musician.push({Name: "Daniel Caesar", Time: "Sunday, 07:00 PM Sep 29, 2024", Genre: "Soul, Gospel", Description: "Daniel Caesar is a Canadian singer and songwriter who has gained global fame with his emotionally rich music style and poetic lyrics. His debut album, 『Freudian』 achieved great success and earned him numerous accolades, including a Grammy Award."});
    musician.push({Name: "Fuji Kaze", Time: "Sunday, 08:00 PM  Sep 29, 2024", Genre: "J-POP", Description: "Fuji Kaze is a rising music talent from Japan who has quickly gained widespread attention with his highly personal voice and creative abilities. His music is loved by fans in Japan and internationally, achieving significant success on digital music platforms."});
    
    tmpText="<div>";
    if(musician.length>0){
        for(let i=0; i<musician.length; i++){
            tmpText += 
            `
            <div id="Schedule_Block2">
                <div>
                    <a href="#"><img class="Schedule_Musician_Pic" src="${RootPath}Common/Image/Cast/${musician[i].Name}2.jpg"></img></a>
                </div>
                <div>
                    <p style="text-align: center; font-family: 'New Amsterdam', sans-serif; font-size: 50px; font-weight: bold; margin: 0;">${musician[i].Name}</p>
                    <p class="Schedule_p">${musician[i].Time}</p>
                    <p class="Schedule_p">Genre: ${musician[i].Genre}</p>
                    <p style="font-family: 'Roboto', sans-serif; font-size: 17px;">${musician[i].Description}</p>
                </div>
            </div>
            `;
        }
        tmpText += "</div>";
        document.getElementById("Schedule_Musician_Cast").innerHTML = tmpText;
    }
})
