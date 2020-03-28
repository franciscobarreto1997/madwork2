const sendParamsToFetchResults = () => {
  const form = document.getElementById('search_form');
  const hidden_form = document.getElementById('hidden_form');
  const submitButton = document.getElementById('submit');

  if (form) {
    // form.addEventListener('submit', (event) => {
    //   event.preventDefault()

    //   hidden_form.elements[0].value = event.target.elements[0].value
    //   hidden_form.elements[0].value = event.target.elements[1].value

    //   hidden_form.submit()
    // })

    submitButton.addEventListener('click', () => {
      hidden_form.elements[0].value = event.target.elements[0].value
      hidden_form.elements[0].value = event.target.elements[1].value

      hidden_form.submit()
      form.submit()
    })
  }
}

export default sendParamsToFetchResults;
