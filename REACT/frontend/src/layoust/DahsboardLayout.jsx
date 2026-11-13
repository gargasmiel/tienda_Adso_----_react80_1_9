/**
*esqueleto visual que comparten todas las paginas del panel
* (inicio, usuarios, categorias, subcategorias, productos):
* sidebar ala izquierda + topbar arriba + el contenido de la 
* pagina actual en el medio(a travez de <Outle/>)
 */

//Outlet marca el punto de donde se pinta la ruta hija activa
import { Outlet } from "react-router-dom";
//menu lateral de navegacion
import Sidebar from '../components/common/Sidebar';
//barra superior con usuario y boton de salir 
import Topbar from '../components/common/Topbar';

//no recibe props: se usa como "element" de la ruta / dashboard en App.jsx
function DashboardLayout(){
    return(
        <div className="d-flex">
            <Sidebar/>
            {/*flex-grow-1 hace que esta columna ocupe todo el espacio restante despues del ancho fijo de sidebar */}
            <div className="flex-grow-1 d-flex flex-column" style={{minHeight:'100vh', backgroundColor:'#f4f6f9'}}>
                <Topbar/>
                <main className="p-4">
                    {/**Outlet renderiza la ruta hija activa DachboardHome, usuariosPage, CategoriaPage,....... segun la url */}
                    <Outlet/>
                </main>
            </div>
        </div>
    )
}

//exportamos el Layout para usarlo en la ruta /dahsboar de app.jsx
export default DashboardLayout;

