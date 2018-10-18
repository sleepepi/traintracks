$(window).on("scroll", ->
  $(".header-container, [data-object~=menu-trigger]").each ->
    pos = $(this).offset().top
    winTop = $(window).scrollTop()
    if pos < winTop
      $(this).addClass "header-container-hide"
      $(".top-menu").addClass("navbar-scrolled")
    else
      $(this).removeClass "header-container-hide"
      $(".top-menu").removeClass("navbar-scrolled")
)
