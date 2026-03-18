<!-- Floating Contact Button -->
<div id="contact-btn"
	class="fixed bottom-28 right-6 opacity-0 translate-y-4  
            transition-all duration-700 ease-out cursor-pointer z-50
            md:bottom-20 md:right-8 bg-transparent border-none">
	<div class="relative flex items-center justify-center">
		<!-- Pulse ring -->
<span class="absolute inline-flex hidden md:block h-15 w-15 rounded-full border border-purple-500 opacity-50 animate-ping"></span>
		<!-- Icon -->
<a href="support" class="cursor-pointer">
		<svg
			class="relative w-10 h-10 md:w-20 md:h-20 text-purple-600 animate-[shake_2s_infinite] 
               "
			viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg"
			fill="currentColor">
      <path
				d="M66 485.5a399.2 315.1 0 1 0 798.4 0 399.2 315.1 0 1 0-798.4 0Z"
				fill="#640dad"></path>
      <path d="M198.6 666.6L148 866.1l197.3-80z" fill="#640dad"></path>
      <path
				d="M906.9 528.5C900.4 672.9 756.6 836 564.7 836c-30.9 0-60 1.3-88.6-4.3 50.1 34.6 118.4 43.7 191.5 43.7 155.9 0 269.3-84.5 276.1-212.4 3-56.3-19-106.4-36.8-134.5z"
				fill="#50c878"></path>
      <path d="M890.3 764.4l35.8 135.5-139.5-54.3z" fill="#50c878"></path>
      <circle cx="309.6" cy="470" r="46.6" fill="#FFFFFF"></circle>
      <circle cx="465.6" cy="470" r="46.6" fill="#FFFFFF"></circle>
      <circle cx="620.8" cy="470" r="46.6" fill="#FFFFFF"></circle>
    </svg>
    </a>
	</div>
</div>

<style>
@
keyframes shake { 0%, 100% {
	transform: rotate(0deg);
}

25
%
{
transform
:
rotate(
3deg
);
}
50
%
{
transform
:
rotate(
-3deg
);
}
75
%
{
transform
:
rotate(
2deg
);
}
}
.animate-\[shake_2s_infinite\] {
	animation: shake 2s infinite;
}
</style>

<script>
  document.addEventListener("DOMContentLoaded", () => {
    const btn = document.getElementById("contact-btn");
    setTimeout(() => {
      btn.classList.remove("opacity-0", "translate-y-4");
      btn.classList.add("opacity-100", "translate-y-0");
    }, 300);
  });
</script>