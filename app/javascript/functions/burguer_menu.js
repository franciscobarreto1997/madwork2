const burguerMenu = () => {
  const burguerMenuButton = document.querySelector('.navbar i');
  const menu = document.querySelector('.menu');

  burguerMenuButton.addEventListener('click', () => {
    if (menu.style.display == 'none') {
      menu.style.display = 'flex';
    } else {
      menu.style.display = 'none';
    }
  })

}

export default burguerMenu;
