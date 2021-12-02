window.onload = function () {
  const url = document.location.href.toLowerCase();

  if (url.includes('user')) {
    const element = (document.querySelector('#users').className = 'active');
    return;
  }
  if (url.includes('exam')) {
    const element = (document.querySelector('#view-exams').className =
      'active');
  }

  if (url.includes('subjects')) {
    const element = (document.querySelector('#subjects').className = 'active');
    return;
  }
  if (url.includes('questions')) {
    const element = (document.querySelector('#questions').className = 'active');
    return;
  }
  if (url.includes('exam') || url.includes('selectquestion')) {
    const element = (document.querySelector('#exams').className = 'active');
    return;
  }
  if (url.includes('results')) {
    const element = (document.querySelector('#results').className = 'active');
    return;
  }
  if (url.includes('settings')) {
    const element = (document.querySelector('#settings').className = 'active');
    return;
  }
  if (url.includes('emails')) {
    const element = (document.querySelector('#email').className = 'active');
    return;
  }
  if (url.includes('reports')) {
    const element = (document.querySelector('#reports').className = 'active');
    return;
  }
  if (url.includes('feedback')) {
    const element = (document.querySelector('#feedback').className = 'active');
    return;
  }
  if (url.includes('categories')) {
    const element = (document.querySelector('#category').className = 'active');
    return;
  }
};
