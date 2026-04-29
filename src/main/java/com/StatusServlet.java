package com.elsa.supervision;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/status")
public class StatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Récupérer les infos système
        OperatingSystemMXBean os = ManagementFactory.getOperatingSystemMXBean();
        Runtime runtime = Runtime.getRuntime();

        // Calcul mémoire
        long totalMemory = runtime.totalMemory() / (1024 * 1024);
        long freeMemory  = runtime.freeMemory()  / (1024 * 1024);
        long usedMemory  = totalMemory - freeMemory;

        // Charge CPU
        double cpuLoad = os.getSystemLoadAverage();

        // Date et heure actuelles
        String timestamp = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));

        // Envoyer les données à la page JSP
        req.setAttribute("timestamp",   timestamp);
        req.setAttribute("totalMemory", totalMemory);
        req.setAttribute("usedMemory",  usedMemory);
        req.setAttribute("freeMemory",  freeMemory);
        req.setAttribute("cpuLoad",     String.format("%.2f", cpuLoad));
        req.setAttribute("osName",      os.getName() + " " + os.getArch());
        req.setAttribute("processors",  os.getAvailableProcessors());
        req.setAttribute("appStatus",   "UP");

        // Rediriger vers la vue JSP
        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp")
           .forward(req, resp);
    }
}
