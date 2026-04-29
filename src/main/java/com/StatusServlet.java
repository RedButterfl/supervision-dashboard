package com.elsa.supervision;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import java.lang.management.RuntimeMXBean;
import java.lang.management.ThreadMXBean;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.TimeUnit;

@WebServlet("/status")
public class StatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        OperatingSystemMXBean os = ManagementFactory.getOperatingSystemMXBean();
        RuntimeMXBean runtime = ManagementFactory.getRuntimeMXBean();
        ThreadMXBean threads = ManagementFactory.getThreadMXBean();
        Runtime jvmRuntime = Runtime.getRuntime();

        // Mémoire
        long totalMemory = jvmRuntime.totalMemory() / (1024 * 1024);
        long freeMemory  = jvmRuntime.freeMemory()  / (1024 * 1024);
        long usedMemory  = totalMemory - freeMemory;
        long memPercent  = (usedMemory * 100) / totalMemory;

        // CPU
        double cpuLoad = os.getSystemLoadAverage();
        if (cpuLoad < 0) cpuLoad = 0;

        // Uptime
        long uptimeMs = runtime.getUptime();
        long hours   = TimeUnit.MILLISECONDS.toHours(uptimeMs);
        long minutes = TimeUnit.MILLISECONDS.toMinutes(uptimeMs) % 60;
        long seconds = TimeUnit.MILLISECONDS.toSeconds(uptimeMs) % 60;
        String uptime = hours + "h " + minutes + "m " + seconds + "s";

        // Threads
        int threadCount = threads.getThreadCount();

        // Statut global
        String status = "UP";
        String statusColor = "#3fb950";
        if (memPercent > 80 || cpuLoad > 2.0) {
            status = "WARNING";
            statusColor = "#f0a500";
        }
        if (memPercent > 95 || cpuLoad > 4.0) {
            status = "CRITICAL";
            statusColor = "#f85149";
        }

        // Timestamp
        String timestamp = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));

        // Envoi à la JSP
        req.setAttribute("timestamp",   timestamp);
        req.setAttribute("totalMemory", totalMemory);
        req.setAttribute("usedMemory",  usedMemory);
        req.setAttribute("freeMemory",  freeMemory);
        req.setAttribute("memPercent",  memPercent);
        req.setAttribute("cpuLoad",     String.format("%.2f", cpuLoad));
        req.setAttribute("processors",  os.getAvailableProcessors());
        req.setAttribute("osName",      os.getName());
        req.setAttribute("osArch",      os.getArch());
        req.setAttribute("javaVersion", System.getProperty("java.version"));
        req.setAttribute("uptime",      uptime);
        req.setAttribute("threadCount", threadCount);
        req.setAttribute("appStatus",   status);
        req.setAttribute("statusColor", statusColor);

        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp")
           .forward(req, resp);
    }
}