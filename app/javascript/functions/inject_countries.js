const injectCountries = () => {
  const selectCountryElement = document.getElementById('country');
  const countries = ['Portugal', 'England', 'United States']

  countries.forEach((country) => {
    selectCountryElement.insertAdjacentHTML('beforeend', `<option value="${country}">${country}</option>`)
  } )
}

export default injectCountries;
