<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>
</head>
<body class="bg-gray-100">
	<%@ include file="/WEB-INF/views/fragment/backToHome.jsp"%>

	<div
		class="flex items-center justify-center px-4 min-h-screen bg-gray-100">
		<div
			class="w-full max-w-4xl bg-white shadow-2xl rounded-2xl overflow-hidden flex flex-col md:flex-row">

			<!-- Side Image -->
			<div class="md:w-1/2 flex items-center justify-center bg-gray-50">
				<img alt="signup image"
					src="${pageContext.request.contextPath}/images/signup.jpeg"
					class="max-h-[350px] w-auto object-contain">
			</div>

			<!-- Signup Form -->
			<div class="md:w-1/2 sm:p-8 flex flex-col justify-center bg-white">
				<h2 class="text-2xl font-extrabold text-gray-800 mb-8">Create
					your account</h2>

				<form class="space-y-4" action="register" method="post">

					<!-- First & Last Name side by side -->
					<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
						<div class="relative">
							<input type="text" id="firstName" name="firstName" required
								placeholder="First Name"
								class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                          focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
							<label for="firstName"
								class="absolute left-1 top-2 text-gray-500 text-sm transition-all
                          peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                          peer-focus:top-2 peer-focus:text-sm">
								First Name </label>
						</div>
						<div class="relative">
							<input type="text" id="lastName" name="lastName" required
								placeholder="Last Name"
								class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                          focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
							<label for="lastName"
								class="absolute left-1 top-2 text-gray-500 text-sm transition-all
                          peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                          peer-focus:top-2 peer-focus:text-sm">
								Last Name </label>
						</div>
					</div>

					<!-- Email -->
					<div class="relative">
						<input type="email" id="email" name="email" required
							placeholder="Email"
							class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                        focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
						<label for="email"
							class="absolute left-1 top-2 text-gray-500 text-sm transition-all
                        peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                        peer-focus:top-2 peer-focus:text-sm">
							Email </label>
					</div>

					<!-- Password -->
					<div class="relative">
						<input type="password" id="password" name="password" required
							placeholder="Password"
							class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                        focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
						<label for="password"
							class="absolute left-1 top-2 text-gray-500 text-sm transition-all
                        peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                        peer-focus:top-2 peer-focus:text-sm">
							Password </label>
					</div>

					<!-- Birth Year -->
					<div class="relative">
						<input type="number" id="birthYear" name="birthYear" required
							min="1900" max="2026" placeholder="Birth Year"
							class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                        focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
						<label for="birthYear"
							class="absolute left-1 top-2 text-gray-500 text-sm transition-all
                        peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                        peer-focus:top-2 peer-focus:text-sm">
							Birth Year </label>
					</div>

					<!-- State & Country side by side -->
					<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
						<div class="relative">
							<input type="text" id="state" name="state" required
								placeholder="State"
								class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                          focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
							<label for="state"
								class="absolute left-1 top-2 text-gray-500 text-sm transition-all
                          peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                          peer-focus:top-2 peer-focus:text-sm">
								State </label>
						</div>
						<div class="relative">
							<input type="text" id="country" name="country" required
								placeholder="Country"
								class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                          focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
							<label for="country"
								class="absolute left-1 top-2 text-gray-500 text-sm transition-all
                          peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                          peer-focus:top-2 peer-focus:text-sm">
								Country </label>
						</div>
					</div>

					<!-- Role -->
					<div class="relative">
						<select name="role" required>
							<option value="VOTER">Voter</option>
							<option value="CONTESTER">Contester</option>
							<option value="ADMIN">Admin</option>
						</select>
					</div>

					<!-- Submit Button -->
					<button type="submit"
						class="cursor-pointer w-full bg-[var(--green)] hover:bg-green-400 text-white py-3 rounded-xl font-semibold transition duration-300 shadow-lg mt-2">
						Sign Up</button>
				</form>

				<!-- Already have account -->
				<p class="text-center text-sm text-gray-600 mt-4">
					Already have an account? <a
						href="${pageContext.request.contextPath}/login.jsp"
						class="text-blue-600 hover:underline">Log in</a>
				</p>
			</div>
		</div>
	</div>

</body>
</html>
