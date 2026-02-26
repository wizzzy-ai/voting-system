<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <title>Legal | SecureVote</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script src="https://cdn.tailwindcss.com"></script>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            /* Professional Dark Gradient */
            background: radial-gradient(circle at 0% 0%, #0f172a 0%, #020617 100%);
            min-height: 100vh;
        }

        /* Glassmorphism Effect */
        .glass-card {
            background: rgba(30, 41, 59, 0.5);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .scroll-reveal {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s cubic-bezier(0.2, 1, 0.3, 1);
        }

        .scroll-reveal.visible {
            opacity: 1;
            transform: translateY(0);
        }

        .animated-underline {
            position: relative;
            display: inline-block;
        }

        .animated-underline::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: -8px;
            width: 40px;
            height: 4px;
            border-radius: 2px;
            background: linear-gradient(to right, #6366f1, #a855f7);
            transition: width 0.4s ease;
        }

        .animated-underline:hover::after {
            width: 100%;
        }

        /* Subtle glow on hover */
        .legal-card:hover {
            border-color: rgba(99, 102, 241, 0.4);
            box-shadow: 0 0 30px rgba(99, 102, 241, 0.1);
        }

        @media (prefers-reduced-motion: reduce) {
            .scroll-reveal { opacity: 1; transform: none; transition: none; }
        }
    </style>
</head>

<body class="text-slate-200 antialiased">

<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>

<main class="pt-20">

    <section id="terms" class="relative overflow-hidden">
        <div class="absolute top-0 left-1/2 -translate-x-1/2 w-full h-96 bg-indigo-500/10 blur-[120px] -z-10"></div>

        <header class="py-20 px-6 text-center">
            <div class="max-w-4xl mx-auto">
                <span class="text-indigo-400 font-bold tracking-[0.2em] uppercase text-sm mb-4 block">Legal Framework</span>
                <h1 class="text-5xl md:text-6xl font-extrabold tracking-tight mb-8 text-white animated-underline">
                    Terms of Service
                </h1>
                <p class="text-slate-400 text-lg md:text-xl font-light max-w-2xl mx-auto leading-relaxed">
                    Rules and regulations governing the secure, transparent, and fair operation of the SecureVote ecosystem.
                </p>
                <div class="mt-8 inline-flex items-center gap-2 bg-white/5 border border-white/10 px-4 py-2 rounded-full text-xs font-medium text-slate-300">
                    <span class="w-2 h-2 rounded-full bg-green-500 animate-pulse"></span>
                    Version 2.4 | Last Updated: February 2026
                </div>
            </div>
        </header>

        <div class="max-w-4xl mx-auto pb-20 px-6 space-y-6">
            <div class="scroll-reveal glass-card p-10 rounded-3xl legal-card transition-all duration-500">
                <div class="flex items-start gap-6">
                    <span class="text-4xl font-black text-white/10">01</span>
                    <div>
                        <h2 class="text-2xl font-bold mb-4 text-white">Introduction & Agreement</h2>
                        <p class="text-slate-400 leading-relaxed">
                            By accessing SecureVote, you enter into a legally binding agreement. 
                            Our platform utilizes advanced cryptographic primitives to ensure that 
                            every vote is cast as intended and remains strictly confidential.
                        </p>
                    </div>
                </div>
            </div>

            <div class="scroll-reveal glass-card p-10 rounded-3xl legal-card transition-all duration-500">
                <div class="flex items-start gap-6">
                    <span class="text-4xl font-black text-white/10">02</span>
                    <div>
                        <h2 class="text-2xl font-bold mb-4 text-white">User Eligibility & Conduct</h2>
                        <ul class="space-y-4 text-slate-400">
                            <li class="flex items-center gap-3">
                                <span class="h-1.5 w-1.5 rounded-full bg-indigo-500"></span>
                                Identity must be verified via authorized election credentials.
                            </li>
                            <li class="flex items-center gap-3">
                                <span class="h-1.5 w-1.5 rounded-full bg-indigo-500"></span>
                                Manipulation, injection attacks, or automation is strictly prohibited.
                            </li>
                            <li class="flex items-center gap-3">
                                <span class="h-1.5 w-1.5 rounded-full bg-indigo-500"></span>
                                Users maintain full responsibility for MFA device security.
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="max-w-4xl mx-auto px-6">
        <div class="h-px bg-gradient-to-right from-transparent via-white/10 to-transparent"></div>
    </div>

    <section id="privacy" class="relative">
        <header class="py-20 px-6 text-center">
            <div class="max-w-4xl mx-auto">
                <h1 class="text-5xl md:text-6xl font-extrabold tracking-tight mb-8 text-white animated-underline">
                    Privacy Policy
                </h1>
                <p class="text-slate-400 text-lg md:text-xl font-light max-w-2xl mx-auto leading-relaxed">
                    Zero-knowledge architecture. Your identity is your own; your ballot is a secret.
                </p>
                <div class="mt-8 flex justify-center gap-4">
                    <span class="px-4 py-1.5 bg-indigo-500/10 border border-indigo-500/20 rounded text-indigo-300 text-xs font-bold uppercase tracking-widest">GDPR</span>
                    <span class="px-4 py-1.5 bg-purple-500/10 border border-purple-500/20 rounded text-purple-300 text-xs font-bold uppercase tracking-widest">CCPA</span>
                </div>
            </div>
        </header>

        <div class="max-w-4xl mx-auto pb-32 px-6 space-y-6">
            <div class="scroll-reveal glass-card p-10 rounded-3xl legal-card transition-all duration-500">
                <div class="flex items-start gap-6">
                    <span class="text-4xl font-black text-white/10">01</span>
                    <div>
                        <h2 class="text-2xl font-bold mb-4 text-white">Data Collection & Minimalist Scope</h2>
                        <p class="text-slate-400 leading-relaxed">
                            We adhere to the principle of data minimization. We only collect the necessary 
                            PII required for verification. Once your cryptographic token is generated, 
                            your personal identity is decoupled from your ballot data.
                        </p>
                    </div>
                </div>
            </div>

            <div class="scroll-reveal glass-card p-10 rounded-3xl legal-card transition-all duration-500">
                <div class="flex items-start gap-6">
                    <span class="text-4xl font-black text-white/10">02</span>
                    <div>
                        <h2 class="text-2xl font-bold mb-4 text-white">Cryptographic Separation</h2>
                        <p class="text-slate-400 leading-relaxed">
                            SecureVote employs sharded database architecture. Authentication logs and 
                            voting records are stored in logically and physically separate environments, 
                            ensuring that even in a breach, a vote cannot be traced back to a specific individual.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

</main>

<%@ include file="/WEB-INF/views/fragment/footer.jsp" %>

<script>
    const observerOptions = {
        threshold: 0.15,
        rootMargin: "0px 0px -50px 0px"
    };

    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                obs.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.scroll-reveal').forEach(el => {
        observer.observe(el);
    });
</script>

</body>
</html>