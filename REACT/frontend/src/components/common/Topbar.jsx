/**
 * barra superior del dashboard muestra nombre del usuario
 * loguado viene del AuthContext y un boton de cerrar sesion
 * 
 */

//hook para navegar progamaticamente(sin que el usuario haga click en un <link>)

import { useNavigate } from 'react-router-dom';
//hook para leer el usuario logueado y la funcion de logout
import { useAuth } from '../../context/authContext.jsx';

//no recibe props, toma todo lo que necesita del AuthContext
 
function Topbar() {
    //usuario datos de quien inicio sesion; logout borra la sesion 
    const {usuario, logout} = useAuth();
    //funcion para cambiar la url desde javascript
    const navigate = useNavigate();
    //al cerrar seesion lipiamos el contexto /localstorage y redirigimos a login
     
    function manejarLogout() {
        logout();
        navigate('/login' ,{replace:true}); 
    }
        return(
            <nav className='navbar navbar-light bg-white border-bottom px-4 py-3'>
                <span className='navbar-brand md-0 h1 fs-6 text-muted'>panel de administrador</span>
                <div className='d-flex align-items-center gap-3'>
                        <div className=' text-end d-none d-md-block'>
                            <div className='fw-semibold'>{usuario?.nombre}</div>
                            <small className='text-muted text-capitalize'>{usuario?.rol}</small>
                        </div>
                         <button className='btn btn-outline-danger btn-sm d-flex align-items-center gap-1' onClick={manejarLogout}>
                            <i className='bi bi-box-arrow-right'></i>Salir
                            </button>
                    </div>
            </nav>
        )
}

export default Topbar;