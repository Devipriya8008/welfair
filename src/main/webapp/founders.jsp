<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>From Founders' Desk – WELFAIR</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Basic Styling -->
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background: #f9f9f9;
        }
        .founders-container {
            max-width: 1200px;
            margin: auto;
            padding: 40px 20px;
        }
        .title {
            text-align: center;
            font-size: 36px;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .subtitle {
            text-align: center;
            font-size: 18px;
            color: #777;
            margin-bottom: 40px;
        }
        .founder-card {
            background: white;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            border-radius: 16px;
            overflow: hidden;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            margin-bottom: 30px;
            transition: transform 0.3s ease;
        }
        .founder-card:hover {
            transform: translateY(-5px);
        }
        .founder-photo {
            flex: 1 1 250px;
            height: 250px;
            background-size: cover;
            background-position: center;
        }
        .founder-info {
            flex: 2 1 400px;
            padding: 25px;
        }
        .founder-name {
            font-size: 24px;
            color: #34495e;
            margin-bottom: 6px;
        }
        .founder-role {
            font-size: 16px;
            color: #888;
            margin-bottom: 6px;
        }
        .founder-email {
            font-size: 14px;
            color: #2c7dbb;
            margin-bottom: 15px;
            display: block;
        }
        .founder-email i {
            margin-right: 6px;
        }
        .founder-note {
            font-size: 16px;
            line-height: 1.6;
            color: #333;
        }

        @media (max-width: 768px) {
            .founder-card {
                flex-direction: column;
            }
            .founder-photo {
                width: 100%;
                height: 300px;
            }
        }
    </style>
</head>
<body>

<div class="founders-container">
    <div class="title">From the Founders' Desk</div>
    <div class="subtitle">Meet the visionaries behind <strong>WELFAIR</strong> – united by compassion, driven by purpose.</div>

    <!-- Founder Cards -->

    <div class="founder-card">
        <div class="founder-photo" style="background-image: url('images/founders/aditya.jpg');"></div>
        <div class="founder-info">
            <div class="founder-name">Aditya Babu</div>
            <div class="founder-role">Co-Founder</div>
            <a href="mailto:23i203@psgtech.ac.in" class="founder-email"><i class="fas fa-envelope"></i>23i203@psgtech.ac.in</a>
            <div class="founder-note">
                "WELFAIR is more than a mission – it's a movement. We're building a future where hope is accessible to all. Every small act of kindness can ripple into a wave of change."
            </div>
        </div>
    </div>

    <div class="founder-card">
        <div class="founder-photo" style="background-image: url('images/founders/devipriya.jpg');"></div>
        <div class="founder-info">
            <div class="founder-name">Devipriya</div>
            <div class="founder-role">Co-Founder</div>
            <a href="mailto:23i212@psgtech.ac.in" class="founder-email"><i class="fas fa-envelope"></i>23i212@psgtech.ac.in</a>
            <div class="founder-note">
                "We created WELFAIR to be a platform of empathy, empowerment, and equal opportunity. Every voice deserves to be heard, and every soul deserves dignity."
            </div>
        </div>
    </div>

    <div class="founder-card">
        <div class="founder-photo" style="background-image: url('images/founders/dhevasrie.jpg');"></div>
        <div class="founder-info">
            <div class="founder-name">Dhevasrie</div>
            <div class="founder-role">Co-Founder</div>
            <a href="mailto:23i214@psgtech.ac.in" class="founder-email"><i class="fas fa-envelope"></i>23i214@psgtech.ac.in</a>
            <div class="founder-note">
                "At WELFAIR, we focus on grassroots impact. Real change starts when communities are uplifted with education, health, and compassion."
            </div>
        </div>
    </div>

    <div class="founder-card">
        <div class="founder-photo" style="background-image: url('images/founders/mohit.jpg');"></div>
        <div class="founder-info">
            <div class="founder-name">Mohit</div>
            <div class="founder-role">Co-Founder</div>
            <a href="mailto:23i240@psgtech.ac.in" class="founder-email"><i class="fas fa-envelope"></i>23i240@psgtech.ac.in</a>
            <div class="founder-note">
                "We envision a society where resources are shared, not hoarded. WELFAIR is our promise to bring equity, support, and transparency to those who need it most."
            </div>
        </div>
    </div>

    <div class="founder-card">
        <div class="founder-photo" style="background-image: url('images/founders/mohnish.jpg');"></div>
        <div class="founder-info">
            <div class="founder-name">Mohnish</div>
            <div class="founder-role">Co-Founder</div>
            <a href="mailto:23i241@psgtech.ac.in" class="founder-email"><i class="fas fa-envelope"></i>23i214@psgtech.ac.in</a>
            <div class="founder-note">
                "Our journey is one of unity, resilience, and relentless hope. WELFAIR is our shared dream – where humanity comes first, always."
            </div>
        </div>
    </div>

</div>

</body>
</html>
