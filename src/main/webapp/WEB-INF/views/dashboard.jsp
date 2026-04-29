<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="10">
  <title>Supervision Dashboard</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: monospace;
      background: #0d1117;
      color: #e6edf3;
      padding: 40px;
    }
    h1 {
      color: #58a6ff;
      font-size: 22px;
      margin-bottom: 6px;
    }
    .subtitle {
      color: #8b949e;
      font-size: 13px;
      margin-bottom: 40px;
    }
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 20px;
    }
    .card {
      background: #161b22;
      border: 1px solid #30363d;
      border-radius: 8px;
      padding: 24px;
    }
    .card .label {
      font-size: 11px;
      color: #8b949e;
      text-transform: uppercase;
      letter-spacing: 0.06em;
      margin-bottom: 10px;
    }
    .card .value {
      font-size: 32px;
      font-weight: bold;
      color: #3fb950;
    }
    .card .unit {
      font-size: 12px;
      color: #8b949e;
      margin-top: 6px;
    }
    .bar {
      background: #30363d;
      border-radius: 4px;
      height: 6px;
      margin-top: 12px;
    }
    .bar-fill {
      background: #58a6ff;
      border-radius: 4px;
      height: 6px;
    }
  </style>
</head>
<body>

  <h1>Supervision Dashboard</h1>
  <p class="subtitle">
    Dernière mise à jour : ${timestamp} — actualisation automatique toutes les 10 secondes
  </p>

  <div class="grid">

    <div class="card">
      <div class="label">Statut application</div>
      <div class="value" style="color:#3fb950">${appStatus}</div>
      <div class="unit">Tomcat opérationnel</div>
    </div>

    <div class="card">
      <div class="label">Mémoire utilisée</div>
      <div class="value">${usedMemory} <span style="font-size:16px">Mo</span></div>
      <div class="unit">sur ${totalMemory} Mo alloués — ${freeMemory} Mo libres</div>
      <div class="bar">
        <div class="bar-fill"
             style="width:${usedMemory * 100 / totalMemory}%">
        </div>
      </div>
    </div>

    <div class="card">
      <div class="label">Charge CPU</div>
      <div class="value">${cpuLoad}</div>
      <div class="unit">charge système moyenne (load average)</div>
    </div>

    <div class="card">
      <div class="label">Processeurs disponibles</div>
      <div class="value">${processors}</div>
      <div class="unit">${osName}</div>
    </div>

  </div>

</body>
</html>