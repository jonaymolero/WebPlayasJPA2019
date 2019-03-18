$(document).ready(function() {
    console.log('ready');
    init();
});

//Funcion que inicializa
function init(){
    $('select').formSelect();
    $('.sidenav').sidenav();
    var instance = M.Carousel.init({
        fullWidth: true,
        indicators: true
    });
    $('.carousel.carousel-slider').carousel({
      fullWidth: true,
      indicators: true
    });
    $('.modal').modal();
    modalVotos();
}

function modalVotos(){
    $('#modal-votos').modal({
        onOpenEnd: function(modal, trigger) {
            $("#nombrePlaya").text("Calificaciones de "+$(trigger).data('nom'));
            $.ajax({
                type: "POST",
                url: "Controller?op=infoPlayas&idplaya=" + $(trigger).data('id'),
                success: function (info) {
                    $("#calificaciones").html(info);
                }
            });
        }
    });
}




