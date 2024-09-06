---
layout: page
title: ElevenLabs AI Audio Challenge
html-title: ElevenLabs AI Audio Challenge
permalink: /ai-audio-challenge
mlinpl-inline-logo: <span class="logo"><span class="main-name">ML <span class="emph">i</span>n PL</span></span>
timeline: 
    - date: 5 October
      description: Deadline to submit the solution
    - date: 7 October
      description: Finalists announced
    - date: 7 November
      description: AI Audio Challenge Finals during ML in PL Conference in Warsaw
category:
    title: '/ <span class="dimond-shine-text">Strategic sponsor</span>'
    imageMaxWidth: 400px
    imageMaxHeight: 220px
    margin: 45px 60px
    sponsors:
        - name: ElevenLabs
          image: "images/sponsors/ElevenLabs.svg"
          url: "https://elevenlabs.io/"
---

The AI Audio Challenge is a competition organised by <strong>ElevenLabs</strong> in partnership with {{ page.mlinpl-inline-logo }}, open to all enthusiasts of applied AI. Participating teams are asked to develop a solution leveraging <strong>ElevenLabs</strong> audio AI technologies.

<ul class="list-inline banner-social-buttons">
    <li>
        <!-- TODO: Fill the link -->
        <a href="" class="btn btn-default btn-lg" target="_blank">Register</a>
    </li>
</ul>

## / Timeline

{% include timeline-inline.html 
    timeline-data=page.timeline
    timeline-col-width=8 
    date-col-width=4
    desc-col-width=8
%}

## / Prizes
<ul>
    <li>1st Prize: 3333 USD + 12 months of ElevenLabs Scale tier subscription</li>
    <li>2nd Prize: 2222 USD + 12 months of ElevenLabs Scale tier subscription</li>
    <li>3rd Prize: 1111 USD + 12 months of ElevenLabs Scale tier subscription</li>
</ul>

Each Finalist will receive ElevenLabs swag and the opportunity to join the Lablab AI Accelerator to bring their solution to life.

## / Strategic Sponsor

{% include logos.html logos-data=page.category.sponsors imageMaxWidth=page.category.imageMaxWidth imageMaxHeight=page.category.imageMaxHeight margin=page.category.margin %}

ElevenLabs supports {{ page.mlinpl-inline-logo }} in its mission as a strategic sponsor of this year’s conference.
