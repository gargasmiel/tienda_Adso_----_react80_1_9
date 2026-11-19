/**
 * componente guardian de ruta se usa envolviendo las rutas del 
 * dashboard en app.jsx si el usuario no esta iniciando sesion lo redirige 
 * automaticamente a la pagina de login en vez de mostrar el contenido
 */

//navigate redirige a otra ruta; Outlet renderiza la ruta hija activa

import { Navigate, Outlet } from "react-router-dom";

//hook para leer el stado de la sesion
import { useAuth } from "../context/authContext";

// no recibe props porque se usa como elemento envolvente en app.jsx
function ProtectedRoutes() {
    //leemos del contexto si hay sesion activa y si todavia esta verficado
    const {estaAutenticado, cargando} = useAuth();
    //mientras se revisa si habia una sesion guardada en localStorjage mostramos un mensaje corto en vez de papadear hacia /login 

    if(cargando){
        return (
            <div className="d-flex justify-content-center align-items-center vh-100">
                <div className="spinner-border text-primary" role="status">
                    <span className="visually-hidden">Cargando...</span>
                </div>
            </div>

        );
    }


    //si no hay sesion activa <Navigate> redirige a /login
    if(!estaAutenticado){
        return <Navigate to="/login" replace />;

    }
    //<Outlet/> renderiza la ruta hija que corresponda 
    //por ejemplo DashboardLayout con sus paginas internas
    return<Outlet/>
}

//Exportamos el componente para usarlo en App.jsx
export default ProtectedRoutes;