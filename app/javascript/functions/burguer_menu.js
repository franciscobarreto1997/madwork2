const burguerMenu = () => {
  const burguerMenuButton = document.querySelector('.navbar i');
  const menu = document.querySelector('.menu');

  burguerMenuButton.addEventListener('click', () => {
    if (menu.style.display == 'none') {
      menu.style.display = 'flex';
      setTimeout(() => {
        menu.classList.remove('opacity');
      }, 15)
    } else {
      menu.classList.add('opacity');
      setTimeout(() => {
        menu.style.display = 'none';
      }, 15)
    }
  })

}

export default burguerMenu;
