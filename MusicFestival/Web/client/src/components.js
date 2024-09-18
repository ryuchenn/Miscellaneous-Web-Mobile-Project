function getBasePath(IsOrigin) {
    let ReturnPath = ""
    
    if (IsOrigin)
        ReturnPath = window.location.origin + '/'; // 'http://127.0.0.1:5501/'
    else // Keeping：'', 'Web', 'client', 'src' -> Result: 'http://127.0.0.1:5501/Web/client/src/'
    {  
        const pathname = window.location.pathname; // '/Web/client/src/Store/store.html'
        const pathArray = pathname.split('/');
        ReturnPath = origin + pathArray.slice(0, 4).join('/') + '/';
    }

    return ReturnPath;
}
const basePath = getBasePath(0);
const RootPath = getBasePath(1);

class TopNavBar extends HTMLElement {
    constructor() {
        
        super();
        const shadow = this.attachShadow({ mode: 'open' }); // Shadow DOM
        
        // HTML
        const container = document.createElement('div');

        // CSS
        container.style.display = 'flex';
        container.style.justifyContent = 'space-between';
        container.style.alignItems = 'center';
        container.style.borderBottom = '5px solid #ebe2e2';

        const style = document.createElement('style');
        style.textContent = `
            a {
                font-family: 'Bungee Tint', sans-serif;
                font-size: 30px;
                text-decoration: none;
                margin: 0 20px;
                padding: 0;
            }

            a:hover {
                background-color: #efcdcd;
                color: #ff0000; 
            }
        `;

        const navLeft = document.createElement('header');
        navLeft.innerHTML = `
        <div style="display: flex; align-items: center; margin: 0; padding: 0;">
            <a href="${basePath}index.html"><img id="ImgLogo" style="width: 150px; margin: 0; padding: 0;" src="${RootPath}Common/Image/Logo-NoBgnd.png" alt="Logo"></a>
            <a href="${basePath}index.html">Home</a>
            <a href="${basePath}Store/store.html">Store</a>
            <a href="${basePath}Schedule/schedule.html">Schedule&Cast</a>
            <a href="${basePath}About/about.html">About</a>
        </div>
        `;

        const navRight = document.createElement('nav');
        navRight.innerHTML = `
        `;

        container.appendChild(navLeft);
        container.appendChild(navRight);
        shadow.appendChild(style);
        shadow.appendChild(container);
    }
}

class FFooter extends HTMLElement {
    constructor() {
        super();
        const shadow = this.attachShadow({ mode: 'open' });

        const container = document.createElement('footer');
        container.style.display = 'flex';
        container.style.justifyContent = 'space-between';
        container.style.alignItems = 'center';
        container.style.padding = '0px';
        container.style.backgroundColor = '#f8f8f8';
        container.style.border = '1px solid #e7e7e7';
        
        const footerLeft = document.createElement('footer');
        footerLeft.innerHTML = `
        `;
        
        const footerMiddle = document.createElement('footer');
        footerMiddle.innerHTML = `
            <div>
                <a href="#"><img style="width: 50px; height: auto; padding-top: 10%; padding-left: 15%" src="${RootPath}Common/Image/facebook.png"></img></a>
                <a href="#"><img style="width: 50px; height: auto;" src="${RootPath}Common/Image/instagram.png"></img></a>
                <a href="#"><img style="width: 50px; height: auto;" src="${RootPath}Common/Image/youtube.png"></img></a>
            </div>
            <p>© 2024 Love Music Festival</p>
            
        `;

        const footerRight = document.createElement('footer');
        footerRight.innerHTML = `
            <language-changer></language-changer>
        `;

        container.appendChild(footerLeft);
        container.appendChild(footerMiddle);
        container.appendChild(footerRight);
        shadow.appendChild(container);
    }
}

class LanguageChanger extends HTMLElement {
    constructor() {
        super();
        const shadow = this.attachShadow({ mode: 'open' });

        const select = document.createElement('select');
        select.style.margin = '0 10px';
        select.innerHTML = `
            <option value="en">English</option>
            <option value="fr">Français</option>
            <option value="zh">中文</option>>
        `;

        select.addEventListener('change', (event) => {
            this.dispatchEvent(new CustomEvent('language-change', {
                detail: { language: event.target.value }
            }));
        });

        shadow.appendChild(select);
    }
}

customElements.define("top-nav-bar", TopNavBar);
customElements.define("f-footer", FFooter);
customElements.define('language-changer', LanguageChanger);

function showNextImage() {
    let currentIndex = 0; 
    const images = document.querySelectorAll('.slideshow_images'); 
    const totalImages = images.length;

    images[currentIndex].classList.remove('active'); 
    currentIndex = (currentIndex+1) % totalImages;
    images[currentIndex].classList.add('active');
}

setInterval(showNextImage, 3000); //change per 3sec