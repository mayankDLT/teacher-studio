window.onload = function () {
  const url = document.location.href.toLowerCase();

  if (url.includes('user') && !url.includes('userreport')) {
    try {
      const element = (document.querySelector('#users').className = 'active');
      return;
    } catch (e) {}
  }
  if (url.includes('exam')) {
    try {
      const element = (document.querySelector('#view-exams').className =
        'active');
    } catch (e) {}
  }

  if (url.includes('subjects')) {
    const element = (document.querySelector('#subjects').className = 'active');
    return;
  }
  if (url.includes('questions')) {
    const element = (document.querySelector('#questions').className = 'active');
    return;
  }
  if (url.includes('category_titles')) {
    const element = (document.querySelector('#org-levels').className =
      'active');
    return;
  }
  if (
    (url.includes('exam') ||
      url.includes('selectquestion') ||
      url.includes('evaluat')) &&
    !url.includes('examreport') &&
    !url.includes('examsresult')
  ) {
    const element = (document.querySelector('#exams').className = 'active');

    return;
  }
  if (url.includes('result')) {
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
  if (
    url.includes('report') ||
    url.includes('overall') ||
    url.includes('pass_fail')
  ) {
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
  if (url.includes('welcome/user_management') || url.includes('groupUser')) {
    const element = (document.querySelector('#users').className = 'active');
    return;
  }
};
