<%-- 
    Document   : playa
    Created on : 08-mar-2019, 9:52:39
    Author     : Diurno
--%>

<%@page import="entities.Usuario"%>
<%@page import="entities.Playa"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Playa playaseleccionada=(Playa)request.getAttribute("playaSeleccionada");
    Usuario user=(Usuario) session.getAttribute("usuario");
%>
<!DOCTYPE html>
  <html>
    <head>
      <!--Import Google Icon Font-->
      <link href="css/fonts.css" rel="stylesheet">
      <!--Import materialize.css-->
      <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>
      <!--Mycss-->
      <link type="text/css" rel="stylesheet" href="css/mycss.css"  media="screen,projection" charset="ISO-8859-1"/>
      
      <!--Let browser know website is optimized for mobile-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    </head>

    <body>
        <div class="container">
            <div class="row">
                <div class="col s12">
                    <nav>
                        <div class="nav-wrapper">
                            <a href="#!" class="brand-logo">Playas</a>
                            <a href="#" data-target="mobile-demo" class="sidenav-trigger"><i class="material-icons">menu</i></a>
                            <ul class="right hide-on-med-and-down">
                                <li><h5>Usuario: <%=user.getNick()%></h5></li>
                                <li><a href="home.jsp" class="waves-effect waves-light btn">Volver</a></li>
                            </ul>
                        </div>
                    </nav>
                    
                    <ul class="sidenav" id="mobile-demo">
                        <li><h5 class="center-align">Usuario: <%=user.getNick()%></h5></li>
                        <li><a href="home.jsp" class="waves-effect waves-light btn">Volver</a></li>
                    </ul>
                </div>
            </div>
            <%if(playaseleccionada.getImagesList()!=null){%>
                <div class="row">
                    <div class="col s12">
                        <div class="carousel-slider carousel">
                            <%for(int i=0;i<playaseleccionada.getImagesList().size();i++){%>
                                <a class="carousel-item" href="#one!"><img class="responsive-img" src="http://playas.chocodev.com/images/<%=playaseleccionada.getId()%>_<%=playaseleccionada.getImagesList().get(i).getId()%>.jpg"></a>
                            <%}%>
                        </div>
                    </div>
                </div>
            <%}%>
            <div class="row">
                <div class="col s12">
                    <h2 class="header center-align"><%=playaseleccionada.getNombre()%></h2>
                    <div class="card horizontal">
                        <div class="card-image">
                            <img id="imagenComunidad" src="img/ccaa_<%=playaseleccionada.getMunicipio().getProvincia().getCcaa().getId()%>.png">
                        </div>
                        <div class="card-stacked">
                          <div class="card-content">
                              <p><%=playaseleccionada.getDescripcion()%></p>
                          </div>
                          <div class="card-action">
                              <p class="negrita">Municipio: <%=playaseleccionada.getMunicipio().getNombre()%></p>
                              <p class="negrita">Provincia <%=playaseleccionada.getMunicipio().getProvincia().getNombre()%></p>
                          </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col s12 center-align">
                    <h3 class="flow-text">Vota aqui abajo</h3>
                </div>
                <div class="col s12 center-align">
                    <a href="Controller?op=voto&rating=1&playaid=<%=playaseleccionada.getId()%>"><img src="img/ic_1.png"/></a>
                    <a href="Controller?op=voto&rating=2&playaid=<%=playaseleccionada.getId()%>"><img src="img/ic_2.png"/></a>
                    <a href="Controller?op=voto&rating=3&playaid=<%=playaseleccionada.getId()%>"><img src="img/ic_3.png"/></a>
                    <a href="Controller?op=voto&rating=4&playaid=<%=playaseleccionada.getId()%>"><img src="img/ic_4.png"/></a>
                    <a href="Controller?op=voto&rating=5&playaid=<%=playaseleccionada.getId()%>"><img src="img/ic_5.png"/></a>
                </div>
            </div>
        </div>
        <!--JQuery-->
        <!--<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>-->
        <!--Compiled and minifed jQuery -->
        <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
        <!--JavaScript at end of body for optimized loading-->
        <script type="text/javascript" src="js/materialize.min.js"></script>
        <!--Myjs-->
        <script type="text/javascript" src="js/myjs.js"></script>
    </body>
  </html>
