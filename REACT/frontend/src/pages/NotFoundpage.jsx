/**
 * 
 */
import{link} from 'react-router-dom';

function notFoundPage() {
    return(
        <div className="d-flex flex-column align-items-center justify-content-center vh-100 text-center px-3">
            <h1 className="display-1 fw-bold">404</h1>
             <p className="text-muted mb-4">Pagina no encontrada
                <link to="/" className='btn btn-primary'>Volver al inicio</link>
             </p>
          </div>  

    )
}