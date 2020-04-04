const colorSourceButton = () => {
  const sourceButtons = document.querySelectorAll('.card .source a');

  if (sourceButtons) {
    sourceButtons.forEach((button) => {
      const source = button.innerText;
      switch(source) {
        case "Landing.jobs":
          button.style.backgroundColor = '#62B9B0';
          break;
        case "Indeed":
          button.style.backgroundColor = '#2164F3';
          break;
        case "GitHub Jobs":
          button.style.backgroundColor = '#2B7FC3';
          break;
        case "remote|OK":
          button.style.backgroundColor = '#FF4742';
          break;
        case "stackoverflow":
          button.style.backgroundColor = '#f48024';
          break;
        default:
          break;
      }
    })
  }
}

export default colorSourceButton;
