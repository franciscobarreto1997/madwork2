const injectCountries = () => {
  const selectCountryElement = document.getElementById('country');
  const countries = ['Portugal', 'England', 'France', 'United States']

  if (selectCountryElement) {
    countries.forEach((country) => {
      selectCountryElement.insertAdjacentHTML('beforeend', `<option value="${country}">${country}</option>`)
    })
  }
}

export default injectCountries;
