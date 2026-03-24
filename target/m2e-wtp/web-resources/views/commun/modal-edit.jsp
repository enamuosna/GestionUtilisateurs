<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .me-overlay {
        position:fixed; inset:0;
        background:rgba(0,0,0,0.55);
        backdrop-filter:blur(5px);
        display:flex; align-items:center; justify-content:center;
        z-index:2000;
        opacity:0; pointer-events:none;
        transition:opacity 0.25s;
    }
    .me-overlay.active { opacity:1; pointer-events:all; }

    .me-modal {
        background:#fff; border-radius:16px;
        width:100%; max-width:520px;
        max-height:90vh; overflow-y:auto;
        box-shadow:0 24px 60px rgba(0,0,0,0.35);
        transform:scale(0.92) translateY(16px);
        transition:transform 0.28s cubic-bezier(0.175,0.885,0.32,1.15);
        scrollbar-width:thin;
    }
    .me-overlay.active .me-modal { transform:scale(1) translateY(0); }

    .me-header {
        background:linear-gradient(135deg,#0f2027,#2c5364);
        padding:20px 28px;
        display:flex; align-items:center; justify-content:space-between;
        border-radius:16px 16px 0 0;
        position:sticky; top:0; z-index:1;
    }
    .me-header-left { display:flex; align-items:center; gap:12px; }
    .me-header-left i  { color:#00c6ff; font-size:22px; }
    .me-header-left h2 { color:#fff; font-size:18px; font-weight:600; }

    .me-close {
        width:32px; height:32px; border-radius:8px;
        background:rgba(255,255,255,0.1);
        border:1px solid rgba(255,255,255,0.2);
        color:#fff; font-size:16px; cursor:pointer;
        display:flex; align-items:center; justify-content:center;
        transition:background 0.2s;
    }
    .me-close:hover { background:rgba(255,107,107,0.3); }

    .me-body { padding:28px; }

    .me-error {
        background:#fdecea; border:1px solid #ef9a9a;
        border-radius:8px; padding:12px 16px; color:#c62828;
        font-size:13px; margin-bottom:20px;
        display:flex; align-items:center; gap:10px;
        animation:meShake 0.4s ease;
    }
    .me-error i { font-size:15px; flex-shrink:0; }

    @keyframes meShake {
        0%,100% { transform:translateX(0);   }
        20%      { transform:translateX(-6px); }
        40%      { transform:translateX(6px);  }
        60%      { transform:translateX(-4px); }
        80%      { transform:translateX(4px);  }
    }

    .me-group { margin-bottom:18px; }
    .me-label {
        display:flex; align-items:center; gap:7px;
        color:#475569; font-size:13px; font-weight:600;
        margin-bottom:7px;
    }
    .me-label i { color:#0072ff; font-size:13px; }

    .me-input-wrap { position:relative; }
    .me-input-wrap i.me-icon {
        position:absolute; left:13px; top:50%;
        transform:translateY(-50%);
        color:#94a3b8; font-size:14px;
        pointer-events:none; transition:color 0.2s;
    }
    .me-input-wrap:focus-within i.me-icon { color:#0072ff; }

    .me-toggle-pw {
        position:absolute; right:13px; top:50%;
        transform:translateY(-50%);
        color:#94a3b8; font-size:14px;
        cursor:pointer; transition:color 0.2s;
    }
    .me-toggle-pw:hover { color:#0072ff; }

    .me-input-wrap input,
    .me-input-wrap select {
        width:100%; padding:11px 14px 11px 38px;
        border:1px solid #cbd5e1; border-radius:8px;
        font-size:14px; color:#1e293b; outline:none;
        transition:border-color 0.2s, box-shadow 0.2s;
        background:#fff;
    }
    .me-input-wrap input:focus,
    .me-input-wrap select:focus {
        border-color:#0072ff;
        box-shadow:0 0 0 3px rgba(0,114,255,0.1);
    }
    .me-input-wrap input.valid   { border-color:#22c55e; }
    .me-input-wrap input.invalid { border-color:#ef4444; }

    .me-hint {
        font-size:11px; color:#94a3b8; margin-top:5px;
        display:flex; align-items:center; gap:5px;
    }
    .me-hint i { font-size:11px; color:#00c6ff; }

    .me-toggle-row {
        display:flex; align-items:center; justify-content:space-between;
        padding:13px 16px;
        background:#f8faff; border:1px solid #e2e8f0;
        border-radius:8px;
    }
    .me-toggle-lbl {
        display:flex; align-items:center; gap:8px;
        font-size:14px; color:#334155; font-weight:600;
    }
    .me-toggle-lbl i { color:#0072ff; }

    .me-switch { position:relative; display:inline-block; width:42px; height:22px; }
    .me-switch input { opacity:0; width:0; height:0; }
    .me-slider {
        position:absolute; cursor:pointer; inset:0;
        background:#cbd5e1; border-radius:22px; transition:background 0.2s;
    }
    .me-slider:before {
        content:""; position:absolute;
        height:16px; width:16px; left:3px; bottom:3px;
        background:#fff; border-radius:50%;
        transition:transform 0.2s;
        box-shadow:0 1px 4px rgba(0,0,0,0.2);
    }
    .me-switch input:checked + .me-slider { background:#0072ff; }
    .me-switch input:checked + .me-slider:before { transform:translateX(20px); }

    .me-btn-row { display:flex; gap:12px; margin-top:24px; }

    .me-btn-cancel {
        flex:1; padding:12px; border:1px solid #cbd5e1;
        border-radius:8px; background:#fff; color:#64748b;
        font-size:14px; font-weight:600; cursor:pointer;
        display:flex; align-items:center; justify-content:center; gap:8px;
        transition:background 0.2s;
    }
    .me-btn-cancel:hover { background:#f1f5f9; }

    .me-btn-submit {
        flex:1; padding:12px; border:none; border-radius:8px;
        background:linear-gradient(135deg,#f59e0b,#d97706);
        color:#fff; font-size:14px; font-weight:600; cursor:pointer;
        display:flex; align-items:center; justify-content:center; gap:8px;
        box-shadow:0 4px 14px rgba(217,119,6,0.3);
        transition:opacity 0.2s, transform 0.1s;
    }
    .me-btn-submit:hover  { opacity:0.88; transform:translateY(-1px); }
    .me-btn-submit:active { transform:scale(0.98); }
</style>

<div class="me-overlay" id="meOverlay">
    <div class="me-modal" id="meModal">

        <div class="me-header">
            <div class="me-header-left">
                <i class="fa-solid fa-user-pen"></i>
                <h2>Modifier l'utilisateur</h2>
            </div>
            <button class="me-close" onclick="fermerModalEdit()" title="Fermer">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <div class="me-body">

            <div class="me-error" id="meError" style="display:none">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span id="meErrorMsg"></span>
            </div>

            <form id="meForm"
                  action="${pageContext.request.contextPath}/users"
                  method="post">

                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id"     id="meId">
                <input type="hidden" name="login"  id="meLogin">

                <div class="me-group">
                    <div class="me-label">
                        <i class="fa-solid fa-id-card"></i> Nom
                    </div>
                    <div class="me-input-wrap">
                        <i class="fa-solid fa-id-card me-icon"></i>
                        <input type="text" id="meNom" name="nom"
                               placeholder="Ex: Diallo" required>
                    </div>
                </div>

                <div class="me-group">
                    <div class="me-label">
                        <i class="fa-solid fa-id-card"></i> Prénom
                    </div>
                    <div class="me-input-wrap">
                        <i class="fa-solid fa-id-card me-icon"></i>
                        <input type="text" id="mePrenom" name="prenom"
                               placeholder="Ex: Mamadou" required>
                    </div>
                </div>

                <div class="me-group">
                    <div class="me-label">
                        <i class="fa-solid fa-envelope"></i> Adresse Email
                    </div>
                    <div class="me-input-wrap">
                        <i class="fa-solid fa-envelope me-icon"></i>
                        <input type="email" id="meEmail" name="email"
                               placeholder="exemple@domaine.com" required>
                    </div>
                </div>

                <div class="me-group">
                    <div class="me-label">
                        <i class="fa-solid fa-lock"></i> Mot de passe
                    </div>
                    <div class="me-input-wrap">
                        <i class="fa-solid fa-lock me-icon"></i>
                        <input type="password" id="mePassword" name="password"
                               placeholder="Laisser vide = ne pas changer">
                        <i class="fa-solid fa-eye me-toggle-pw"
                           id="meTogglePw"></i>
                    </div>
                    <p class="me-hint">
                        <i class="fa-solid fa-circle-info"></i>
                        Laissez vide pour conserver le mot de passe actuel.
                    </p>
                </div>

                <div class="me-group">
                    <div class="me-label">
                        <i class="fa-solid fa-tag"></i> Rôle
                    </div>
                    <div class="me-input-wrap">
                        <i class="fa-solid fa-tag me-icon"></i>
                        <select id="meRole" name="role">
                            <option value="USER">Utilisateur</option>
                            <option value="ADMIN">Administrateur</option>
                        </select>
                    </div>
                </div>

                <div class="me-group">
                    <div class="me-toggle-row">
                        <div class="me-toggle-lbl">
                            <i class="fa-solid fa-circle-half-stroke"></i>
                            Compte actif
                        </div>
                        <label class="me-switch">
                            <input type="checkbox" id="meActif" name="actif">
                            <span class="me-slider"></span>
                        </label>
                    </div>
                </div>

                <div class="me-btn-row">
                    <button type="button" class="me-btn-cancel"
                            onclick="fermerModalEdit()">
                        <i class="fa-solid fa-xmark"></i> Annuler
                    </button>
                    <button type="submit" class="me-btn-submit">
                        <i class="fa-solid fa-floppy-disk"></i>
                        Enregistrer
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {

    var overlay  = document.getElementById('meOverlay');
    var pwInput  = document.getElementById('mePassword');
    var togglePw = document.getElementById('meTogglePw');
    var emailIn  = document.getElementById('meEmail');
    var form     = document.getElementById('meForm');
    var errBox   = document.getElementById('meError');
    var errMsg   = document.getElementById('meErrorMsg');

    window.ouvrirModalEdit = function (id, nom, prenom, email, role, actif, login) {

        form.reset();
        errBox.style.display = 'none';
        pwInput.type = 'password';
        if (togglePw) togglePw.className = 'fa-solid fa-eye me-toggle-pw';

        document.getElementById('meId').value     = id;
        document.getElementById('meLogin').value  = login || '';
        document.getElementById('meNom').value    = nom;
        document.getElementById('mePrenom').value = prenom;
        document.getElementById('meEmail').value  = email;
        document.getElementById('meRole').value   = role;
        document.getElementById('meActif').checked = (actif === 'true');

        overlay.classList.add('active');
        setTimeout(function () {
            document.getElementById('meNom').focus();
        }, 280);
    };

    window.fermerModalEdit = function () {
        overlay.classList.remove('active');
    };

    overlay.addEventListener('click', function (e) {
        if (e.target === overlay) fermerModalEdit();
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') fermerModalEdit();
    });

    if (togglePw) {
        togglePw.addEventListener('click', function () {
            var visible  = pwInput.type === 'text';
            pwInput.type = visible ? 'password' : 'text';
            this.className = visible
                ? 'fa-solid fa-eye me-toggle-pw'
                : 'fa-solid fa-eye-slash me-toggle-pw';
        });
    }

    if (emailIn) {
        emailIn.addEventListener('input', function () {
            var ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.value);
            this.classList.toggle('valid',   this.value.length > 0 && ok);
            this.classList.toggle('invalid', this.value.length > 0 && !ok);
        });
    }

    if (form) {
        form.addEventListener('submit', function (e) {
            var nom    = document.getElementById('meNom').value.trim();
            var prenom = document.getElementById('mePrenom').value.trim();
            var email  = emailIn.value.trim();

            if (!nom || !prenom) {
                e.preventDefault();
                afficherErreur('Veuillez remplir le nom et le prénom.');
                return;
            }
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                e.preventDefault();
                afficherErreur('Adresse email invalide.');
                return;
            }
        });
    }

    function afficherErreur(msg) {
        errMsg.textContent   = msg;
        errBox.style.display = 'flex';
        errBox.scrollIntoView({ behavior:'smooth', block:'nearest' });
    }

});
</script>