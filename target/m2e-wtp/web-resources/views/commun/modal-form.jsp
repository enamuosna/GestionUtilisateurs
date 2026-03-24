<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .mf-overlay {
        position:fixed; inset:0;
        background:rgba(0,0,0,0.55);
        backdrop-filter:blur(5px);
        display:flex; align-items:center; justify-content:center;
        z-index:2000;
        opacity:0; pointer-events:none;
        transition:opacity 0.25s;
    }
    .mf-overlay.active {
        opacity:1; pointer-events:all;
    }

 
    .mf-modal {
        background:#fff;
        border-radius:16px;
        width:100%; max-width:520px;
        max-height:90vh;
        overflow-y:auto;
        box-shadow:0 24px 60px rgba(0,0,0,0.35);
        transform:scale(0.92) translateY(16px);
        transition:transform 0.28s cubic-bezier(0.175,0.885,0.32,1.15);
        scrollbar-width:thin;
    }
    .mf-overlay.active .mf-modal {
        transform:scale(1) translateY(0);
    }

    .mf-header {
        background:linear-gradient(135deg,#0f2027,#2c5364);
        padding:20px 28px;
        display:flex; align-items:center; justify-content:space-between;
        border-radius:16px 16px 0 0;
        position:sticky; top:0; z-index:1;
    }
    .mf-header-left {
        display:flex; align-items:center; gap:12px;
    }
    .mf-header-left i  { color:#00c6ff; font-size:22px; }
    .mf-header-left h2 { color:#fff; font-size:18px; font-weight:600; }

    .mf-close {
        width:32px; height:32px; border-radius:8px;
        background:rgba(255,255,255,0.1);
        border:1px solid rgba(255,255,255,0.2);
        color:#fff; font-size:16px; cursor:pointer;
        display:flex; align-items:center; justify-content:center;
        transition:background 0.2s;
    }
    .mf-close:hover { background:rgba(255,107,107,0.3); }

    .mf-body { padding:28px; }

    .mf-error {
        background:#fdecea; border:1px solid #ef9a9a;
        border-radius:8px; padding:12px 16px; color:#c62828;
        font-size:13px; margin-bottom:20px;
        display:flex; align-items:center; gap:10px;
        animation:mfShake 0.4s ease;
    }
    .mf-error i { font-size:15px; flex-shrink:0; }

    @keyframes mfShake {
        0%,100% { transform:translateX(0);   }
        20%      { transform:translateX(-6px); }
        40%      { transform:translateX(6px);  }
        60%      { transform:translateX(-4px); }
        80%      { transform:translateX(4px);  }
    }

    .mf-group { margin-bottom:18px; }

    .mf-label {
        display:flex; align-items:center; gap:7px;
        color:#475569; font-size:13px; font-weight:600;
        margin-bottom:7px;
    }
    .mf-label i { color:#0072ff; font-size:13px; }
    
    .mf-input-wrap { position:relative; }

    .mf-input-wrap i.mf-icon {
        position:absolute; left:13px; top:50%;
        transform:translateY(-50%);
        color:#94a3b8; font-size:14px;
        pointer-events:none;
        transition:color 0.2s;
    }
    .mf-input-wrap:focus-within i.mf-icon { color:#0072ff; }

    .mf-toggle-pw {
        position:absolute; right:13px; top:50%;
        transform:translateY(-50%);
        color:#94a3b8; font-size:14px;
        cursor:pointer; transition:color 0.2s;
    }
    .mf-toggle-pw:hover { color:#0072ff; }

    .mf-input-wrap input,
    .mf-input-wrap select {
        width:100%; padding:11px 14px 11px 38px;
        border:1px solid #cbd5e1; border-radius:8px;
        font-size:14px; color:#1e293b; outline:none;
        transition:border-color 0.2s, box-shadow 0.2s;
        background:#fff;
    }
    .mf-input-wrap input:focus,
    .mf-input-wrap select:focus {
        border-color:#0072ff;
        box-shadow:0 0 0 3px rgba(0,114,255,0.1);
    }
    .mf-input-wrap input.valid   { border-color:#22c55e; }
    .mf-input-wrap input.invalid { border-color:#ef4444; }

    .mf-strength { margin-top:7px; display:none; }
    .mf-strength-bar {
        height:4px; border-radius:4px;
        background:#e2e8f0; overflow:hidden; margin-bottom:4px;
    }
    .mf-strength-fill {
        height:100%; border-radius:4px;
        width:0%; transition:width 0.3s, background 0.3s;
    }
    .mf-strength-label {
        font-size:11px; color:#94a3b8;
        display:flex; align-items:center; gap:4px;
    }

    .mf-toggle-row {
        display:flex; align-items:center; justify-content:space-between;
        padding:13px 16px;
        background:#f8faff; border:1px solid #e2e8f0;
        border-radius:8px;
    }
    .mf-toggle-lbl {
        display:flex; align-items:center; gap:8px;
        font-size:14px; color:#334155; font-weight:600;
    }
    .mf-toggle-lbl i { color:#0072ff; }

    .mf-switch {
        position:relative; display:inline-block;
        width:42px; height:22px;
    }
    .mf-switch input { opacity:0; width:0; height:0; }
    .mf-slider {
        position:absolute; cursor:pointer; inset:0;
        background:#cbd5e1; border-radius:22px;
        transition:background 0.2s;
    }
    .mf-slider:before {
        content:""; position:absolute;
        height:16px; width:16px; left:3px; bottom:3px;
        background:#fff; border-radius:50%;
        transition:transform 0.2s;
        box-shadow:0 1px 4px rgba(0,0,0,0.2);
    }
    .mf-switch input:checked + .mf-slider { background:#0072ff; }
    .mf-switch input:checked + .mf-slider:before { transform:translateX(20px); }

    .mf-btn-row { display:flex; gap:12px; margin-top:24px; }

    .mf-btn-cancel {
        flex:1; padding:12px; border:1px solid #cbd5e1;
        border-radius:8px; background:#fff; color:#64748b;
        font-size:14px; font-weight:600; cursor:pointer;
        display:flex; align-items:center; justify-content:center; gap:8px;
        transition:background 0.2s;
    }
    .mf-btn-cancel:hover { background:#f1f5f9; }

    .mf-btn-submit {
        flex:1; padding:12px; border:none; border-radius:8px;
        background:linear-gradient(135deg,#00c6ff,#0072ff);
        color:#fff; font-size:14px; font-weight:600; cursor:pointer;
        display:flex; align-items:center; justify-content:center; gap:8px;
        box-shadow:0 4px 14px rgba(0,114,255,0.3);
        transition:opacity 0.2s, transform 0.1s;
    }
    .mf-btn-submit:hover  { opacity:0.88; transform:translateY(-1px); }
    .mf-btn-submit:active { transform:scale(0.98); }
</style>

<div class="mf-overlay" id="mfOverlay">
    <div class="mf-modal" id="mfModal">

        <div class="mf-header">
            <div class="mf-header-left">
                <i class="fa-solid fa-user-plus"></i>
                <h2>Nouvel utilisateur</h2>
            </div>
            <button class="mf-close" onclick="fermerModalForm()" title="Fermer">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <div class="mf-body">


            <div class="mf-error" id="mfError" style="display:none">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span id="mfErrorMsg"></span>
            </div>

            <form id="mfForm"
                  action="${pageContext.request.contextPath}/users"
                  method="post">

                <input type="hidden" name="action" value="create">

                <div class="mf-group">
                    <div class="mf-label">
                        <i class="fa-solid fa-id-card"></i> Nom
                    </div>
                    <div class="mf-input-wrap">
                        <i class="fa-solid fa-id-card mf-icon"></i>
                        <input type="text" id="mfNom" name="nom"
                               placeholder="Ex: Diallo" required>
                    </div>
                </div>

                <div class="mf-group">
                    <div class="mf-label">
                        <i class="fa-solid fa-id-card"></i> Prénom
                    </div>
                    <div class="mf-input-wrap">
                        <i class="fa-solid fa-id-card mf-icon"></i>
                        <input type="text" id="mfPrenom" name="prenom"
                               placeholder="Ex: Mamadou" required>
                    </div>
                </div>

                <div class="mf-group">
                    <div class="mf-label">
                        <i class="fa-solid fa-envelope"></i> Adresse Email
                    </div>
                    <div class="mf-input-wrap">
                        <i class="fa-solid fa-envelope mf-icon"></i>
                        <input type="email" id="mfEmail" name="email"
                               placeholder="exemple@domaine.com" required>
                    </div>
                </div>

                <div class="mf-group">
                    <div class="mf-label">
                        <i class="fa-solid fa-lock"></i> Mot de passe
                    </div>
                    <div class="mf-input-wrap">
                        <i class="fa-solid fa-lock mf-icon"></i>
                        <input type="password" id="mfPassword" name="password"
                               placeholder="Minimum 6 caractères" required>
                        <i class="fa-solid fa-eye mf-toggle-pw"
                           id="mfTogglePw"></i>
                    </div>
                    <div class="mf-strength" id="mfStrength">
                        <div class="mf-strength-bar">
                            <div class="mf-strength-fill" id="mfStrengthFill"></div>
                        </div>
                        <div class="mf-strength-label">
                            <i class="fa-solid fa-shield-halved"
                               style="font-size:10px"></i>
                            <span id="mfStrengthLabel"></span>
                        </div>
                    </div>
                </div>

                <div class="mf-group">
                    <div class="mf-label">
                        <i class="fa-solid fa-tag"></i> Rôle
                    </div>
                    <div class="mf-input-wrap">
                        <i class="fa-solid fa-tag mf-icon"></i>
                        <select name="role">
                            <option value="USER">Utilisateur</option>
                            <option value="ADMIN">Administrateur</option>
                        </select>
                    </div>
                </div>

                <div class="mf-group">
                    <div class="mf-toggle-row">
                        <div class="mf-toggle-lbl">
                            <i class="fa-solid fa-circle-half-stroke"></i>
                            Compte actif
                        </div>
                        <label class="mf-switch">
                            <input type="checkbox" name="actif" checked>
                            <span class="mf-slider"></span>
                        </label>
                    </div>
                </div>

                <div class="mf-btn-row">
                    <button type="button" class="mf-btn-cancel"
                            onclick="fermerModalForm()">
                        <i class="fa-solid fa-xmark"></i> Annuler
                    </button>
                    <button type="submit" class="mf-btn-submit" id="mfSubmit">
                        <i class="fa-solid fa-user-plus"></i>
                        Créer l'utilisateur
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {

    var overlay  = document.getElementById('mfOverlay');
    var pwInput  = document.getElementById('mfPassword');
    var togglePw = document.getElementById('mfTogglePw');
    var strength = document.getElementById('mfStrength');
    var fill     = document.getElementById('mfStrengthFill');
    var lbl      = document.getElementById('mfStrengthLabel');
    var emailIn  = document.getElementById('mfEmail');
    var form     = document.getElementById('mfForm');
    var errBox   = document.getElementById('mfError');
    var errMsg   = document.getElementById('mfErrorMsg');

    window.ouvrirModalForm = function () {
        form.reset();
        strength.style.display = 'none';
        errBox.style.display   = 'none';
        /* Réinitialiser classes valid/invalid */
        var inputs = form.querySelectorAll('input');
        inputs.forEach(function (i) {
            i.classList.remove('valid', 'invalid');
        });
        overlay.classList.add('active');
        setTimeout(function () {
            document.getElementById('mfNom').focus();
        }, 280);
    };

    window.fermerModalForm = function () {
        overlay.classList.remove('active');
    };


    overlay.addEventListener('click', function (e) {
        if (e.target === overlay) fermerModalForm();
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') fermerModalForm();
    });

    if (togglePw) {
        togglePw.addEventListener('click', function () {
            var visible  = pwInput.type === 'text';
            pwInput.type = visible ? 'password' : 'text';
            this.className = visible
                ? 'fa-solid fa-eye mf-toggle-pw'
                : 'fa-solid fa-eye-slash mf-toggle-pw';
        });
    }

    if (pwInput) {
        pwInput.addEventListener('input', function () {
            if (this.value.length === 0) {
                strength.style.display = 'none';
                return;
            }
            strength.style.display = 'block';

            var score = 0;
            if (this.value.length >= 6)          score++;
            if (this.value.length >= 10)         score++;
            if (/[A-Z]/.test(this.value))        score++;
            if (/[0-9]/.test(this.value))        score++;
            if (/[^A-Za-z0-9]/.test(this.value)) score++;

            var lvls = [
                { pct:'20%',  color:'#ef4444', txt:'Très faible' },
                { pct:'40%',  color:'#f97316', txt:'Faible'      },
                { pct:'60%',  color:'#eab308', txt:'Moyen'       },
                { pct:'80%',  color:'#22c55e', txt:'Fort'        },
                { pct:'100%', color:'#16a34a', txt:'Très fort'   }
            ];
            var l = lvls[Math.min(score, 4)];
            fill.style.width      = l.pct;
            fill.style.background = l.color;
            lbl.textContent       = l.txt;
            lbl.style.color       = l.color;
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
            var nom    = document.getElementById('mfNom').value.trim();
            var prenom = document.getElementById('mfPrenom').value.trim();
            var email  = emailIn.value.trim();
            var pw     = pwInput.value;

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
            if (pw.length < 6) {
                e.preventDefault();
                afficherErreur('Le mot de passe doit contenir au moins 6 caractères.');
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