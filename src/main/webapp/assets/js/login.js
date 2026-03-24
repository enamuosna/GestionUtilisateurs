document.addEventListener('DOMContentLoaded', function () {

    const passwordInput = document.getElementById('password');
    const toggleBtn     = document.getElementById('togglePassword');

    if (toggleBtn && passwordInput) {
        toggleBtn.addEventListener('click', function () {
            const visible = passwordInput.type === 'text';
            passwordInput.type      = visible ? 'password' : 'text';
            toggleBtn.className     = visible
                ? 'fa-solid fa-eye toggle-password'
                : 'fa-solid fa-eye-slash toggle-password';
        });
    }

    const form      = document.getElementById('loginForm');
    const btnText   = document.getElementById('btnText');
    const btnIcon   = document.getElementById('btnIcon');
    const spinner   = document.getElementById('btnSpinner');
    const submitBtn = document.getElementById('submitBtn');

    if (form) {
        form.addEventListener('submit', function () {
            if (spinner)   spinner.style.display   = 'block';
            if (btnIcon)   btnIcon.style.display    = 'none';
            if (btnText)   btnText.textContent      = 'Connexion...';
            if (submitBtn) submitBtn.disabled       = true;
        });
    }

    const emailInput = document.getElementById('email');

    if (emailInput) {
        emailInput.addEventListener('input', function () {
            const valid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.value);
            this.style.borderColor = this.value.length === 0
                ? 'rgba(255,255,255,0.15)'
                : (valid ? '#00c6ff' : '#ff6b6b');
        });
    }

    if (emailInput && emailInput.value.trim() === '') {
        emailInput.focus();
    } else if (passwordInput) {
        passwordInput.focus();
    }

    const demoBtn = document.getElementById('demoBtn');
    if (demoBtn) {
        demoBtn.addEventListener('click', function () {
            if (emailInput)    emailInput.value    = 'admin@gest.sn';
            if (passwordInput) passwordInput.value = 'admin123';
            if (emailInput)    emailInput.dispatchEvent(new Event('input'));
        });
    }

});