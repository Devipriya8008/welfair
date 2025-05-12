<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="sidebar">
    <div class="sidebar-header p-3">
        <h4 class="text-white mb-0">Admin Panel</h4>
    </div>
    <div class="sidebar-content">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link ${param.table == null ? 'active' : ''}" href="admin-dashboard">
                    <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.table == 'donors' ? 'active' : ''}" href="admin-table?table=donors">
                    <i class="bi bi-people me-2"></i> Donors
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.table == 'donations' ? 'active' : ''}" href="admin-table?table=donations">
                    <i class="bi bi-cash-stack me-2"></i> Donations
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.table == 'projects' ? 'active' : ''}" href="admin-table?table=projects">
                    <i class="bi bi-kanban me-2"></i> Projects
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.table == 'beneficiaries' ? 'active' : ''}" href="admin-table?table=beneficiaries">
                    <i class="bi bi-heart me-2"></i> Beneficiaries
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.table == 'employees' ? 'active' : ''}" href="admin-table?table=employees">
                    <i class="bi bi-person-badge me-2"></i> Employees
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.table == 'volunteers' ? 'active' : ''}" href="admin-table?table=volunteers">
                    <i class="bi bi-person-plus me-2"></i> Volunteers
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.table == 'inventory' ? 'active' : ''}" href="admin-table?table=inventory">
                    <i class="bi bi-box-seam me-2"></i> Inventory
                </a>
            </li>
        </ul>
    </div>
</div>

<style>
    .sidebar {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        z-index: 1000;
        width: 250px;
        background: linear-gradient(180deg, #2b2d42 0%, #1a1a2e 100%);
        box-shadow: 4px 0 10px rgba(0, 0, 0, 0.1);
        overflow-y: auto;
        height: 100vh;
        transition: transform 0.3s ease;
    }

    .sidebar-header {
        background: rgba(0,0,0,0.2);
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    .sidebar-content {
        padding: 10px 0;
    }

    .sidebar .nav-link {
        color: rgba(255, 255, 255, 0.8);
        padding: 0.75rem 1.5rem;
        margin: 0.15rem 1rem;
        border-radius: 8px;
        font-weight: 500;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        white-space: nowrap;
        font-size: 0.9rem;
    }

    .sidebar .nav-link:hover {
        color: white;
        background: rgba(255, 255, 255, 0.1);
        transform: translateX(5px);
    }

    .sidebar .nav-link.active {
        color: white;
        background: #4361ee;
        box-shadow: 0 4px 15px rgba(67, 97, 238, 0.3);
    }

    .sidebar .nav-link i {
        font-size: 1.1rem;
        min-width: 24px;
    }

    @media (max-width: 768px) {
        .sidebar {
            transform: translateX(-100%);
        }
        .sidebar.active {
            transform: translateX(0);
        }
    }
</style>

<script>
    // Enhanced scroll position maintenance
    document.addEventListener('DOMContentLoaded', function() {
        const sidebar = document.querySelector('.sidebar-content');
        const navLinks = document.querySelectorAll('.sidebar .nav-link');

        // Load saved scroll position
        const savedScroll = sessionStorage.getItem('sidebarScroll');
        if (savedScroll) {
            sidebar.scrollTop = savedScroll;
        }

        // Save scroll position before navigation
        navLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                sessionStorage.setItem('sidebarScroll', sidebar.scrollTop);

                // For mobile, close sidebar after click
                if (window.innerWidth <= 768) {
                    document.querySelector('.sidebar').classList.remove('active');
                }
            });
        });

        // Save scroll position before page unload
        window.addEventListener('beforeunload', function() {
            sessionStorage.setItem('sidebarScroll', sidebar.scrollTop);
        });
    });
</script>