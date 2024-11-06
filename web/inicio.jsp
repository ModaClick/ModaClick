<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bienvenido - Sistema ModaClick</title>
    <link rel="stylesheet" type="text/css" href="recursos/dist/css/bootstrap.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            overflow: hidden; /* Evitar el scroll */
            background-color: #f8f9fa; /* Color de fondo claro */
        }

        .hero {
            position: relative;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            text-align: center;
            overflow: hidden;
            background: rgba(0, 0, 0, 0.5); /* Fondo oscuro semi-transparente */
        }

        video {
            position: absolute;
            top: 50%;
            left: 50%;
            min-width: 100%;
            min-height: 100%;
            width: auto;
            height: auto;
            z-index: 1;
            opacity: 0.5; /* Ajusta la opacidad del video */
            transform: translate(-50%, -50%);
            background: url('presentacion/logo.jpg') no-repeat; /* Imagen de fondo en caso de que no se cargue el video */
            background-size: cover;
        }

        .hero h1 {
            font-size: 3.5rem;
            font-weight: bold;
            z-index: 2; /* Asegura que el texto esté encima del video */
            margin: 0;
        }

        .hero .tagline {
            font-size: 1.5rem;
            margin: 10px 0;
            z-index: 2;
        }

        .hero p {
            font-size: 1.5rem;
            margin: 20px 0;
            z-index: 2;
        }

        .btn-whatsapp {
            background-color: #25D366; /* Color verde de WhatsApp */
            color: white;
            border: none;
            padding: 10px 2px;
            border-radius: 15px;
            font-size: 1.2rem;
            text-decoration: none;
            width: 130px;
            z-index: 1;
            transition: background-color 0.3s;
            display: flex;
            align-items: center; /* Centrar verticalmente el ícono y el texto */
            justify-content: center; /* Centrar horizontalmente el texto */
            position: fixed; /* Posicionarlo en la esquina inferior derecha */
            bottom: 30px; /* Espacio desde el fondo */
            right: 30px; /* Espacio desde el lado derecho */
        }

        .btn-whatsapp i {
            margin-right: 10px; /* Espacio entre el ícono y el texto */
            margin-left: 10px; /* Espacio entre el ícono y el texto */
        }

        .btn-whatsapp:hover {
            background-color: #128C7E; /* Color más oscuro al pasar el mouse */
        }

        .footer {
            background-color: #343a40; /* Color del footer */
            color: white;
            text-align: center;
            padding: 15px 0;
            position: absolute;
            bottom: 0;
            width: 100%;
        }

        .footer p {
            margin: 0;
        }

        .logo-title {
            position: relative;
            z-index: 2;
            margin-bottom: 20px;
        }

        .logo-title img {
            width: 400px; /* Ajusta el tamaño del logo */
            border-radius: 180%; /* Hace que el logo sea redondo */
            background: transparent; /* Asegura que no haya fondo */
        }

        .contact-buttons {
            margin-top: 20px;
            z-index: 2;
        }
    </style>
</head>
<body>
    <div class="hero">
        <video autoplay muted loop>
            <source src="presentacion/videoalmacen.mp4" type="video/mp4">
            Tu navegador no soporta el video.
        </video>
        <div class="logo-title">
            <img src="presentacion/logo.bmp" alt="Logo MODACLICK"> <!-- Asegúrate de que el archivo sea PNG y sin fondo -->
        </div>
        <h1>MODACLICK</h1>
        <p class="tagline">A un click de tu gusto</p> <!-- Mensaje debajo del título -->
        <p>Gestión de Ventas de Ropa y Cobijas</p>
    </div>

    <a href="https://wa.me/573152425479" class="btn btn-whatsapp" target="_blank">
        <i class="fab fa-whatsapp"></i> Ayuda y soporte
    </a> <!-- Botón de ayuda y soporte con ícono en la esquina inferior derecha -->

    <footer class="footer">
        <p>&copy; 2024 MODACLICK. Todos los derechos reservados.</p>
    </footer>
</body>
</html>
