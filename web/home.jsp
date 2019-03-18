<%-- 
    Document   : home
    Created on : 08-mar-2019, 9:03:58
    Author     : Diurno
--%>

<%@page import="entities.Usuario"%>
<%@page import="entities.Playa"%>
<%@page import="entities.Municipio"%>
<%@page import="entities.Provincia"%>
<%@page import="java.util.List"%>
<%@page import="entities.Ccaa"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Ccaa> listaComunidades=(List<Ccaa>)session.getAttribute("listaComunidades");
    List<Provincia> listaProvincias=(List<Provincia>)session.getAttribute("listaProvincias");
    List<Municipio> listaMunicipios=(List<Municipio>)session.getAttribute("listaMunicipios");
    List<Playa> listaPlayas=(List<Playa>)session.getAttribute("listaPlayas");
    Usuario user=(Usuario) session.getAttribute("usuario");
    String mensaje=(String) request.getAttribute("mensaje");
    
    String idComunidad=(String) session.getAttribute("comboComunidad");
    String idProvincia=(String) session.getAttribute("comboProvincias");
    String idMunicipio=(String) session.getAttribute("comboMunicipios");
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
                                <%if(user==null){%>
                                    <li><a class="waves-effect waves-light btn modal-trigger" href="#modal-login">Login&Register</a></li>
                                    
                                <%}else{%>
                                    <li><h5>Bienvenido <%=user.getNick()%></h5></li>
                                    <li><a href="Controller?op=logout" class="waves-effect waves-light btn">Logout</a></li>
                                <%}%>
                            </ul>
                        </div>
                    </nav>
                    
                    <ul class="sidenav" id="mobile-demo">
                        <%if(user==null){%>
                            <li><a class="waves-effect waves-light btn modal-trigger" href="#modal-login">Login&Register</a></li>

                        <%}else{%>
                            <li><h5 class="center-align">Bienvenido <%=user.getNick()%></h5></li>
                            <li><a href="Controller?op=logout" class="waves-effect waves-light btn">Logout</a></li>
                        <%}%>
                    </ul>
                </div>
            </div>
            <div class="row">
                <div class="col s4">
                    <form action="Controller?op=comunidad" method="post">
                        <select id="selectComunidad" name="selectComunidad" onchange='this.form.submit()'>
                            <option value="" disabled selected>Comunidad autonoma</option>
                            <%for(Ccaa comunidad:listaComunidades){%>
                                <option value="<%=comunidad.getId()%>"><%=comunidad.getNombre()%></option>
                            <%}%>
                        </select>
                    </form>
                </div>
                <%if(listaProvincias!=null){%>
                    <div class="col s4">
                        <form action="Controller?op=provincia" method="post">
                            <select id="selectProvincia" name="selectProvincia" onchange='this.form.submit()'>
                                <option value="" disabled selected>Provincia</option>
                                <%for(Provincia provincia:listaProvincias){%>
                                    <option value="<%=provincia.getId()%>"><%=provincia.getNombre()%></option>
                                <%}%>
                            </select>
                        </form>
                    </div>
                <%}%>
                <%if(listaMunicipios!=null){%>
                    <div class="col s4">
                        <form action="Controller?op=municipio" method="post">
                            <select id="selectMunicipio" name="selectMunicipio" onchange='this.form.submit()'>
                                <option value="" disabled selected>Municipio</option>
                                <%for(Municipio municipio : listaMunicipios){%>
                                    <option value="<%=municipio.getId()%>"><%=municipio.getNombre()%></option>
                                <%}%>
                            </select>
                        </form>
                    </div>
                <%}%>
            </div>
            <%if(listaPlayas!=null){%>
            <div class="row">
                <%for(Playa playa : listaPlayas){%>
                    <div class="col s12">
                        <h2 class="header"><%=playa.getNombre() %></h2>
                        <div class="card horizontal">
                            <div class="card-image">
                                <img src="http://playas.chocodev.com/images/<%=playa.getId()%>_<%=playa.getImagesList().get(0).getId()%>.jpg">
                            </div>
                            <div class="card-stacked">
                            <div class="card-content">
                                <p><%=playa.getDescripcion()%></p>
                            </div>
                            <%if(user!=null){%>
                                <div class="card-action">
                                    <button data-target="modal-votos" data-id="<%=playa.getId()%>" data-nom="<%=playa.getNombre()%>" class="btn modal-trigger">Calificaciones</button>
                                    <a class="waves-effect waves-light btn" href="Controller?op=info&id=<%=playa.getId()%>">Info</a>
                                </div>
                            <%}%>
                            </div>
                        </div>
                    </div>
                <%}%>
            </div>
            <%}%>
        </div>
        
        <!-- Modal Calificaciones -->
        <div id="modal-votos" class="modal">
          <div class="modal-content">
            <h4 id="nombrePlaya"></h4>
            <div id="calificaciones">
                
            </div>
          </div>
          <div class="modal-footer">
            <a href="#!" class="modal-close waves-effect waves-green btn">Aceptar</a>
          </div>
        </div>
        
        <!--Modal login-->
        <div id="modal-login" class="modal">
            <form action="Controller?op=login" method="post">
                <div class="modal-content">
                  <h4>Login&Register</h4>
                  <div class="input-field col s6">
                    <input placeholder="Nick" id="nick" name="nick" type="text" class="validate" required>
                  </div>
                  <div class="input-field col s6">
                    <input placeholder="Pass" id="pass" name="pass" type="password" class="validate" required>
                  </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="waves-effect waves-light btn">Aceptar</button>
                    <a href="#!" class="modal-close waves-effect waves-green btn">Cancelar</a>
                </div>
            </form>
        </div>
        
        <!--JQuery-->
        <!--<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>-->
        <!--Compiled and minifed jQuery -->
        <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
        <!--JavaScript at end of body for optimized loading-->
        <script type="text/javascript" src="js/materialize.min.js"></script>
        <!--Myjs-->
        <script type="text/javascript" src="js/myjs.js"></script>
        <%if(idComunidad!=null){%>
            <script type="text/javascript">
                $('#selectComunidad').val('<%=idComunidad%>');
            </script>
        <%}%>
        <%if(idProvincia!=null){%>
            <script type="text/javascript">
                $('#selectProvincia').val('<%=idProvincia%>');
            </script>
        <%}%>
        <%if(idMunicipio!=null){%>
            <script type="text/javascript">
                $('#selectMunicipio').val('<%=idMunicipio%>');
            </script>
        <%}%>
        <%if(mensaje!=null){%>
            <script type="text/javascript">
                M.toast({html: '<%=mensaje%>', classes: 'rounded'});
            </script>
        <%}%>
    </body>
  </html>
