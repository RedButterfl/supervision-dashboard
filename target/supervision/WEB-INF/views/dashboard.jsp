<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String statusColor = (String) request.getAttribute("statusColor");
  if (statusColor == null) statusColor = "#3fb950";
  String memPercent = String.valueOf(request.getAttribute("memPercent"));
  long memP = 0;
  try { memP = Long.parseLong(memPercent); } catch(Exception e) {}
  String barClass = memP > 95 ? "critical" : memP > 80 ? "warning" : "";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="10">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Supervision Dashboard</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #0d1117; color: #e6edf3; min-height: 100vh; }

    .header {
      background: #161b22;
      border-bottom: 1px solid #30363d;
      padding: 16px 32px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .header-left { display: flex; align-items: center; gap: 12px; }
    .header-title { font-size: 18px; font-weight: 600; }
    .header-subtitle { font-size: 13px; color: #8b949e; margin-top: 2px; }
    .header-time { font-size: 12px; color: #8b949e; font-family: monospace; }

    .main { padding: 32px; max-width: 1200px; margin: 0 auto; }
    .section-title {
      font-size: 11px; text-transform: uppercase;
      letter-spacing: 0.08em; color: #8b949e;
      margin-bottom: 16px; margin-top: 32px;
    }

    .grid-4 { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; }
    .grid-3 { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; }

    .card {
      background: #161b22;
      border: 1px solid #30363d;
      border-radius: 10px;
      padding: 20px 24px;
    }
    .card-label {
      font-size: 11px; text-transform: uppercase;
      letter-spacing: 0.06em; color: #8b949e; margin-bottom: 10px;
    }
    .card-value { font-size: 34px; font-weight: 700; line-height: 1; }
    .card-value span { font-size: 16px; font-weight: 400; color: #8b949e; margin-left: 4px; }
    .card-sub { font-size: 12px; color: #8b949e; margin-top: 8px; }
    .card-info-value { font-size: 16px; font-weight: 600; font-family: monospace; }

    .bar-bg { background: #30363d; border-radius: 4px; height: 6px; margin-top: 12px; overflow: hidden; }
    .bar-fill { height: 6px; border-radius: 4px; background: #58a6ff; }
    .bar-fill.warning { background: #f0a500; }
    .bar-fill.critical { background: #f85149; }

    .footer {
      text-align: center; padding: 24px;
      font-size: 12px; color: #484f58;
      border-top: 1px solid #21262d; margin-top: 40px;
    }

    @media (max-width: 900px) { .grid-4,.grid-3 { grid-template-columns: repeat(2,1fr); } }
    @media (max-width: 600px) { .grid-4,.grid-3 { grid-template-columns: 1fr; } .main { padding: 16px; } }
  </style>
</head>
<body>

  <div class="header">
    <div class="header-left">
      <div style="width:10px;height:10px;border-radius:50%;background:<%= statusColor %>;box-shadow:0 0 8px <%= statusColor %>"></div>
      <div>
        <div class="header-title">Supervision Dashboard</div>
        <div class="header-subtitle">Elsa MOUKOUDI — INSA Lyon</div>
      </div>
    </div>
    <div style="display:flex;align-items:center;gap:16px;">
      <span style="background:<%= statusColor %>22;border:1px solid <%= statusColor %>66;color:<%= statusColor %>;padding:4px 12px;border-radius:20px;font-size:13px;font-weight:600;">${appStatus}</span>
      <span class="header-time">Mis à jour : ${timestamp}</span>
    </div>
  </div>

  <div class="main">

    <div class="section-title">Métriques principales</div>
    <div class="grid-4">

      <div class="card" style="background:<%= statusColor %>11;border-color:<%= statusColor %>44;">
        <div class="card-label">Statut application</div>
        <div class="card-value" style="font-size:28px;color:<%= statusColor %>">${appStatus}</div>
        <div class="card-sub">Apache Tomcat 9.0.117</div>
      </div>

      <div class="card">
        <div class="card-label">Mémoire utilisée</div>
        <div class="card-value">${usedMemory}<span>Mo</span></div>
        <div class="card-sub">sur ${totalMemory} Mo — ${memPercent}% utilisé</div>
        <div class="bar-bg">
          <div class="bar-fill <%= barClass %>" style="width:${memPercent}%"></div>
        </div>
      </div>

      <div class="card">
        <div class="card-label">Charge CPU</div>
        <div class="card-value">${cpuLoad}</div>
        <div class="card-sub">${processors} processeurs disponibles</div>
      </div>

      <div class="card">
        <div class="card-label">Uptime serveur</div>
        <div class="card-value" style="font-size:22px">${uptime}</div>
        <div class="card-sub">depuis le dernier démarrage</div>
      </div>

    </div>

    <div class="section-title">Informations système</div>
    <div class="grid-3">

      <div class="card">
        <div class="card-label">Système d'exploitation</div>
        <div class="card-info-value">${osName}</div>
        <div class="card-sub">Architecture : ${osArch}</div>
      </div>

      <div class="card">
        <div class="card-label">Version Java</div>
        <div class="card-info-value">Java ${javaVersion}</div>
        <div class="card-sub">JVM OpenJDK — Eclipse Adoptium</div>
      </div>

      <div class="card">
        <div class="card-label">Threads actifs</div>
        <div class="card-value">${threadCount}</div>
        <div class="card-sub">threads JVM en cours d'exécution</div>
      </div>

    </div>

    <div class="section-title">Mémoire détaillée</div>
    <div class="grid-3">

      <div class="card">
        <div class="card-label">Mémoire utilisée</div>
        <div class="card-value" style="color:#f85149">${usedMemory}<span>Mo</span></div>
      </div>

      <div class="card">
        <div class="card-label">Mémoire libre</div>
        <div class="card-value" style="color:#3fb950">${freeMemory}<span>Mo</span></div>
      </div>

      <div class="card">
        <div class="card-label">Mémoire totale allouée</div>
        <div class="card-value" style="color:#58a6ff">${totalMemory}<span>Mo</span></div>
      </div>

    </div>

  </div>

  <div class="footer">
    Supervision Dashboard · Apache Tomcat 9.0.117 · Java ${javaVersion} · Actualisation toutes les 10 secondes
  </div>

</body>
</html>