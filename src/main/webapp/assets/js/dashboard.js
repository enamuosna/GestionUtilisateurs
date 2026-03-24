document.addEventListener('DOMContentLoaded', function () {

    const cards = document.querySelectorAll('.menu-card');
    cards.forEach(function (card, index) {
        setTimeout(function () {
            card.classList.add('visible');
        }, 100 + index * 80);
    });

    cards.forEach(function (card) {
        card.addEventListener('mouseenter', function () {
            this.querySelector('.card-icon').style.transform = 'scale(1.12) rotate(-4deg)';
        });
        card.addEventListener('mouseleave', function () {
            this.querySelector('.card-icon').style.transform = 'scale(1) rotate(0deg)';
        });
    });

    const logoutCard = document.getElementById('logoutCard');
    if (logoutCard) {
        logoutCard.addEventListener('click', function (e) {
            e.preventDefault();
            const href = this.getAttribute('href');
            if (confirm('Voulez-vous vraiment vous déconnecter ?')) {
                window.location.href = href;
            }
        });
    }

    const welcomeTitle = document.querySelector('.welcome h2');
    if (welcomeTitle) {
        welcomeTitle.style.opacity  = '0';
        welcomeTitle.style.transform = 'translateY(10px)';
        setTimeout(function () {
            welcomeTitle.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            welcomeTitle.style.opacity    = '1';
            welcomeTitle.style.transform  = 'translateY(0)';
        }, 200);
    }

});