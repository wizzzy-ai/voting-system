<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>
<body class="bg-gray-100">
<%@ include file="/WEB-INF/views/fragment/backToHome.jsp" %>

<div class="flex items-center justify-center px-4 min-h-screen bg-gray-100 mt-6">
  <div class="w-full max-w-4xl bg-white shadow-2xl rounded-2xl overflow-hidden flex flex-col md:flex-row">
    
    <div class="md:w-1/2">
      <img alt="login image" src="${pageContext.request.contextPath}/images/login.jpeg" 
           class="w-full h-full object-cover hidden md:block">
    </div>
    
    <!-- Login Form -->
    <div class="md:w-1/2 p-10 sm:p-16 flex flex-col justify-center bg-white">
      <h2 class="text-2xl font-extrabold text-gray-800 mb-8">Sign in to your account</h2>

      <% if (request.getAttribute("error") != null) { %>
        <div class="mb-4 p-3 bg-red-100 text-red-700 rounded">
          <%= request.getAttribute("error") %>
        </div>
      <% } %>

      <form class="space-y-4" action="login" method="post">
        
        <!-- Email -->
        <div class="relative">
          <input
            type="email"
            id="email"
            name="email"
            required
            placeholder="Email address"
            class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                   focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1"
          />
          <label for="email"
            class="absolute left-1 top-2 text-gray-500 text-sm transition-all
                   peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                   peer-focus:top-2 peer-focus:text-sm">
            Email address
          </label>
        </div>

        <!-- Password -->
        <div class="relative">
          <input
            type="password"
            id="password"
            name="password"
            required
            placeholder="Password"
            class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                   focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1"
          />
          <label for="password"
            class="absolute left-1 top-2 text-gray-500 text-sm transition-all
                   peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                   peer-focus:top-2 peer-focus:text-sm">
            Password
          </label>
        </div>

        <!-- Options -->
        <div class="flex items-center justify-between text-sm">
          <label class="flex items-center gap-2 text-gray-600">
            <input type="checkbox" class="accent-blue-600" />
            Remember me
          </label>
          <a href="#" class="text-blue-600 hover:underline">Forgot password?</a>
        </div>

        <!-- Submit Button -->
        <button type="submit"
          class="cursor-pointer w-full bg-[var(--green)] hover:bg-green-700 text-white py-3 rounded-xl font-semibold transition duration-300 shadow-lg mt-2">
          Sign In
        </button>
      </form>

      <!-- Divider -->
      <div class="flex items-center gap-4 my-2">
        <hr class="flex-grow border-gray-300" />
        <span class="text-gray-400 text-sm">OR</span>
        <hr class="flex-grow border-gray-300" />
      </div>

      <!-- Google Login -->
      <button class="flex items-center justify-center gap-3 py-2 px-4 border border-gray-300 rounded-xl bg-white hover:bg-gray-100 transition">
        <img src="https://www.svgrepo.com/show/475656/google-color.svg" class="w-5 h-5" alt="Google" />
        Continue with Google
      </button>

      <!-- Sign Up Link -->
      <p class="text-center text-sm text-gray-600 mt-4">
        Don't have an account?
        <a href="${pageContext.request.contextPath}/register.jsp" class="text-blue-600 hover:underline">Sign up</a>
      </p>
    </div>
  </div>
</div>

</body>
</html>