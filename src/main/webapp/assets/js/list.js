document.addEventListener('DOMContentLoaded', function () {

    const ctx = document.getElementById('appContext')
                    ? document.getElementById('appContext').value
                    : '';

    const overlay    = document.getElementById('modalOverlay');
    const modalNom   = document.getElementById('modalNom');
    const confirmBtn = document.getElementById('modalConfirmBtn');

    window.ouvrirModal = function (id, nom) {
        if (!overlay || !modalNom || !confirmBtn) return;
        modalNom.textContent = nom;
        confirmBtn.onclick = function (e) {
            e.preventDefault();
            var form = document.createElement('form');
            form.method = 'post';
            form.action = ctx + '/users';
            var fields = {action: 'delete', id: id};
            for (var k in fields) {
                var inp = document.createElement('input');
                inp.type  = 'hidden';
                inp.name  = k;
                inp.value = fields[k];
                form.appendChild(inp);
            }
            document.body.appendChild(form);
            form.submit();
        };
        overlay.classList.add('active');
    };

    window.fermerModal = function () {
        if (overlay) overlay.classList.remove('active');
    };

    if (overlay) {
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) fermerModal();
        });
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') fermerModal();
    });

    document.querySelectorAll('.alert').forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            alert.style.opacity    = '0';
            alert.style.transform  = 'translateY(-8px)';
            setTimeout(function () { alert.style.display = 'none'; }, 500);
        }, 4000);
    });

    document.querySelectorAll('.stat-card').forEach(function (card, i) {
        card.style.opacity    = '0';
        card.style.transform  = 'translateY(16px)';
        setTimeout(function () {
            card.style.transition = 'opacity 0.4s ease, transform 0.4s ease, box-shadow 0.2s';
            card.style.opacity    = '1';
            card.style.transform  = 'translateY(0)';
        }, 80 + i * 80);
    });

});
