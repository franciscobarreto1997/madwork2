import burguerMenu from './burguer_menu';

const responsiveNavbar = () => {
  const mediaQuery = window.matchMedia( "(max-width: 812px)");

  mediaQuery.addListener(widthChange);
  widthChange(mediaQuery);
}

const widthChange = (mq) => {

  const aboutButton = document.querySelector('.about-button');
  const navbar = document.querySelector('.navbar');

  if (mq.matches) {
    aboutButton.parentNode.removeChild(aboutButton);
    navbar.insertAdjacentHTML('beforeend','<i class="fas fa-bars"></i>');

    document.querySelector('.navbar i').style.fontSize = '35px';
    burguerMenu()
  }
}

export default responsiveNavbar;
