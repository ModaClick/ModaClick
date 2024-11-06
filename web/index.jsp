<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html> 
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - MODACLICK</title>
    <link rel="stylesheet" type="text/css" href="recursos/dist/css/bootstrap.css">
    <link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Cedarville+Cursive&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&display=swap" rel="stylesheet">
    <style>
        body {
            background-image: url("presentacion/fondo3.jpg");       
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center center;
            background-attachment: fixed;
            font-family: 'Poppins', sans-serif;
        }
        .login-container {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 15px;
        }
        .login-wrapper {
            background: rgba(255, 255, 255, 0.8);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0px 4px 30px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
        }
        .logo-title {
            display: flex;
            align-items: center;
            justify-content: left;
            margin-bottom: 20px;
        }
        .logo-title img {
            width: 50px;
            margin-right: 10px;
        }
        .logo-title h1 {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin: 0;
            font-family: "Dancing Script", cursive;
        }
        .input-group {
            margin-bottom: 20px;
            position: relative;
            width: 100%;
        }
        .input-group .form-control {
            border-radius: 50px;
            padding-left: 50px;
            height: 60px;
            width: 100%;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .input-group .form-control:focus {
            border-color: #38a1db;
            box-shadow: 0 0 5px rgba(56, 161, 219, 0.5);
        }
        .input-group .input-group-text {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            font-size: 1.5rem;
            height: 60px;
            display: flex;
            align-items: center;
        }
        .btn-primary {
            border-radius: 50px;
            padding: 10px 20px;
            background-color: #38a1db;
            border: none;
            width: 100%;
            height: 60px;
            transition: background-color 0.3s;
        }
        .btn-primary:hover {
            background-color: #007bb5;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-wrapper">
            <div class="logo-title">
                <img src="presentacion/logo1.jpg" alt="Logo MODACLICK">
                <h1>ModaClick</h1>
            </div>
            <h1>Iniciar Sesión</h1>
            <form name="formulario" method="post" action="validar.jsp">
                <div class="input-group">
                    <span class="input-group-text"><i class='bx bxs-user'></i></span>
                    <input type="text" name="identificacion" class="form-control" required="" placeholder="Usuario" autocomplete="off">
                </div>
                <div class="input-group">
                    <span class="input-group-text"><i class='bx bxs-lock-alt'></i></span>
                    <input type="password" name="clave" class="form-control" required="" placeholder="Contraseña" autocomplete="off">
                </div>
                <input type="submit" class="btn btn-primary btn-block" value="Iniciar Sesión">
            </form>
        </div>
    </div>
</body>
</html>
