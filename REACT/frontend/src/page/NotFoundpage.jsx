/**
 * componente guardian de ruta se usa envolviendo las rutas del 
 * dashboard en app.jsx si el usuario no esta iniciando sesion lo redirige 
 * automaticamente a la pagina de login en vez de mostrar el contenido
 */

//navigate redirige a otra ruta; Outlet renderiza la ruta hija activa

import { Navigate, Outlet } from "react-router-dom";

//hook para leer el stado de la sesion
import { useAuth } from "../context/authContext";