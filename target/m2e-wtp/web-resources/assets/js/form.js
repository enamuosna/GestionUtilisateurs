document.addEventListener('DOMContentLoaded', function () {

    const passwordInput = document.getElementById('password');
    const toggleBtn     = document.getElementById('togglePassword');

    if (toggleBtn && passwordInput) {
        toggleBtn.addEventListener('click', function () {
            const visible       = passwordInput.type === 'text';
            passwordInput.type  = visible ? 'password' : 'text';
            toggleBtn.className = visible
                ? 'fa-solid fa-eye toggle-password'
                : 'fa-solid fa-eye-slash toggle-password';
        });
    }

    const strengthBar    = document.getElementById('strengthFill');
    const strengthLabel  = document.getElementById('strengthLabel');
    const strengthWidget = document.getElementById('passwordStrength');

    if (passwordInput && strengthBar) {
        passwordInput.addEventListener('input', function () {
            const val = this.value;

            if (val.length === 0) {
                strengthWidget.style.display = 'none';
                return;
            }

            strengthWidget.style.display = 'block';

            let score = 0;
            if (val.length >= 6)               score++;
            if (val.length >= 10)              score++;
            if (/[A-Z]/.test(val))             score++;
            if (/[0-9]/.test(val))             score++;
            if (/[^A-Za-z0-9]/.test(val))      score++;

            const levels = [
                { pct:'20%', color:'#ef4444', label:'Très faible' },
                { pct:'40%', color:'#f97316', label:'Faible'      },
                { pct:'60%', color:'#eab308', label:'Moyen'       },
                { pct:'80%', color:'#22c55e', label:'Fort'        },
                { pct:'100%',color:'#16a34a', label:'Très fort'   }
            ];

            const lvl = levels[Math.min(score, 4)];
            strengthBar.style.width      = lvl.pct;
            strengthBar.style.background = lvl.color;
            strengthLabel.textContent    = lvl.label;
            strengthLabel.style.color    = lvl.color;
        });
    }

    const emailInput = document.getElementById('email');
    if (emailInput) {
        emailInput.addEventListener('input', function () {
            const valid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.value);
            this.classList.toggle('valid',   this.value.length > 0 && valid);
            this.classList.toggle('invalid', this.value.length > 0 && !valid);
        });
    }

    const requiredInputs = document.querySelectorAll('input[required]');
    requiredInputs.forEach(function (input) {
        input.addEventListener('blur', function () {
            if (this.value.trim() === '') {
                this.classList.add('invalid');
                this.classList.remove('valid');
            } else {
                this.classList.remove('invalid');
                if (this.type !== 'email') this.classList.add('valid');
            }
        });
    });

    const firstInput = document.querySelector('.card-body input:not([type=hidden])');
    if (firstInput) firstInput.focus();

});