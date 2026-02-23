<header class="flex flex-wrap items-center py-4 px-4 absolute top-0 left-0 w-full z-20 
               sm:bg-white md:bg-transparent">

  <div class="flex-1 flex justify-between items-center">
    <a href="#">
      <img alt="Logo"
           class="cursor-pointer lg:h-[50px] lg:w-[230px] h-[45px] w-[140px]"
           src="${pageContext.request.contextPath}/images/logos/logoShort.png">
    </a>
    
<!-- Theme toggle button -->
<button id="theme-toggle"
        class="h-12 w-12 rounded-lg p-2 hover:bg-gray-100 dark:hover:bg-gray-700">
  
  <!-- Moon icon (light mode) -->
  <svg id="moon-icon" class="fill-violet-700 block dark:hidden" fill="currentColor" viewBox="0 0 20 20">
    <path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"></path>
  </svg>
  
  <!-- Sun icon (dark mode) -->
  <svg id="sun-icon" class="fill-yellow-500 hidden dark:block" fill="currentColor" viewBox="0 0 20 20">
    <path d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z"
          fill-rule="evenodd" clip-rule="evenodd"></path>
  </svg>
</button>
  </div>

  <!-- Hamburger / Close button -->
  <button id="menu-toggle" class="cursor-pointer md:hidden focus:outline-none">
    <!-- Hamburger icon -->
    <svg id="hamburger-icon" class="fill-current text-[var(--purple)] " xmlns="http://www.w3.org/2000/svg"
        width="45px" height="45px" viewBox="0 0 20 20">
      <path d="M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z"></path>
    </svg>
    
    <!-- Close icon (hidden by default) -->
   <svg class="hidden fill-current" id="close-icon" width="45px" height="45px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" 
   stroke="#6A0DAD"><g id="SVGRepo_bgCarrier" stroke-width="0"></g>
   <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> 
   <path d="M20.7457 3.32851C20.3552 2.93798 19.722 2.93798 19.3315 3.32851L12.0371 10.6229L4.74275 3.32851C4.35223 2.93798 3.71906 2.93798 3.32854 3.32851C2.93801 3.71903 2.93801 4.3522 3.32854 4.74272L10.6229 12.0371L3.32856 19.3314C2.93803 19.722 2.93803 20.3551 3.32856 20.7457C3.71908 21.1362 4.35225 21.1362 4.74277 20.7457L12.0371 13.4513L19.3315 20.7457C19.722 21.1362 20.3552 21.1362 20.7457 20.7457C21.1362 20.3551 21.1362 19.722 20.7457 19.3315L13.4513 12.0371L20.7457 4.74272C21.1362 4.3522 21.1362 3.71903 20.7457 3.32851Z" fill="#0F0F0F">
   </path> </g></svg>
  </button>

  <!-- Desktop menu (unchanged) -->
  <div class="hidden md:flex md:items-center md:w-auto w-full " id="menu-desktop">
  
    <nav>
      <ul class="md:flex items-center justify-between text-base text-gray-700 pt-4 md:pt-0">
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-white" href="#">About us</a></li>
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-white" href="#">Contact</a></li>
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-white" href="#">Live results</a></li>
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-white" href="#">Login</a></li>
        <li><a class="md:p-4 py-3 px-0 block font-bold rounded-sm 
                      bg-gradient-to-r from-[var(--purple-light)] to-[var(--purple)] text-white 
                      transition-transform duration-300 hover:scale-105 
                      hover:bg-gradient-to-r hover:from-[var(--purple)] hover:to-[var(--purple-light)]" href="${pageContext.request.contextPath}/">Register</a></li>
      </ul>

    </nav>
  </div>

  <!-- Mobile drop down menu -->
  <div id="menu-mobile"
       class="hidden h-[400px] md:hidden absolute top-full left-0 w-full bg-white shadow-lg transform scale-y-0 origin-top transition-transform duration-300 ease-in-out">
    <nav>
      <ul class="flex flex-col items-center text-base text-gray-700 py-4">
        <li><a class="py-2 px-4 block relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-[black] mb-4 text-2xl" href="#">About us</a></li>
        <li><a class="py-2 px-4 block relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-[black] mb-4 text-2xl" href="#">Contact</a></li>
        <li><a class="py-2 px-4 block relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-[black] mb-4 text-2xl" href="#">Live Results</a></li>
        <li><a class="py-2 px-4 block relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-[black] mb-4 text-2xl" href="#">Login</a></li>
        <li><a class="py-2 px-4 block relative inline-block 
                      text-[black] mb-4 text-2xl border border-groove rounded-sm" href="#">Register</a></li>
      </ul>
    </nav>
  </div>
</header>

<script type="text/javascript">
const toggleBtn = document.getElementById('menu-toggle');
const menuMobile = document.getElementById('menu-mobile');
const hamburgerIcon = document.getElementById('hamburger-icon');
const closeIcon = document.getElementById('close-icon');

toggleBtn.addEventListener('click', () => {
  const isOpen = menuMobile.classList.contains('scale-y-100');
  if (isOpen) {
    // Close menu
    menuMobile.classList.remove('scale-y-100');
    menuMobile.classList.add('scale-y-0');
    hamburgerIcon.classList.remove('hidden');
    closeIcon.classList.add('hidden');
  } else {
    // Open menu
    menuMobile.classList.remove('scale-y-0', 'hidden');
    menuMobile.classList.add('scale-y-100');
    hamburgerIcon.classList.add('hidden');
    closeIcon.classList.remove('hidden');
  }
});

//theme toggle button
document.addEventListener('DOMContentLoaded', () => {
	  const toggleBtn = document.getElementById('theme-toggle');

	  toggleBtn.addEventListener('click', () => {
	    document.documentElement.classList.toggle('dark');
	  });
	});

</script>