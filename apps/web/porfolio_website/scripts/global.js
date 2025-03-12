// JavaScript for injecting the global HTML content (Header, Navbar & Footer).
window.addEventListener('DOMContentLoaded', (event) => {
    // Fetch the global content
    fetch('../pages/_global.html')
        .then(response => response.text())
        .then(data => {
            // Create a temporary container to parse the HTML
            const tempContainer = document.createElement('div');
            tempContainer.innerHTML = data;

            // Extract the header and nav content (everything before the footer)
            const headerContent = tempContainer.querySelector('header').outerHTML +
                                 tempContainer.querySelector('nav').outerHTML;

            // Extract just the footer content
            const footerContent = tempContainer.querySelector('footer').outerHTML;

            // Inject the header content into the 'global-header' div
            document.getElementById('global-header').innerHTML = headerContent;

            // Inject the footer content into the 'global-footer' div
            document.getElementById('global-footer').innerHTML = footerContent;
        })
        .catch(error => console.error('Error loading global content:', error));
});