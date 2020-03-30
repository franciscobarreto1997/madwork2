const changeSourceButtonOnHover = () => {
  const cards = document.querySelectorAll('.card');

  if (cards) {
    cards.forEach((card) => {
      card.addEventListener('mouseenter', () => {
        const sourceLink = card.querySelector('a');
        sourceLink.style.backgroundColor = 'white';
        sourceLink.style.color = '#04B0FF'
      })
      card.addEventListener('mouseleave', () => {
        const sourceLink = card.querySelector('a');
        sourceLink.style.backgroundColor = '#04B0FF';
        sourceLink.style.color = 'white'
      })
    })
  }
}

export default changeSourceButtonOnHover;
