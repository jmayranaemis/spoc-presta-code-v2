{strip}
{if $icon == 'season-winter'}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <path d="M12 3v18"/>
    <path d="m8 5 4 3 4-3"/>
    <path d="m8 19 4-3 4 3"/>
    <path d="M4.5 7.5 19.5 16.5"/>
    <path d="M19.5 7.5 4.5 16.5"/>
    <path d="m5.3 12.7 4.4-1.2 1.2-4.4"/>
    <path d="m18.7 11.3-4.4 1.2-1.2 4.4"/>
  </svg>
{elseif $icon == 'season-summer'}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <circle cx="12" cy="12" r="4"/>
    <path d="M12 2.5v3"/>
    <path d="M12 18.5v3"/>
    <path d="m4.9 4.9 2.1 2.1"/>
    <path d="m17 17 2.1 2.1"/>
    <path d="M2.5 12h3"/>
    <path d="M18.5 12h3"/>
    <path d="m4.9 19.1 2.1-2.1"/>
    <path d="m17 7 2.1-2.1"/>
  </svg>
{elseif $icon == 'gender'}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <circle cx="12" cy="5.5" r="2.5"/>
    <path d="M12 8v6.2"/>
    <path d="M8.5 11h7"/>
    <path d="M12 14.2 8 21"/>
    <path d="m12 14.2 4 6.8"/>
  </svg>
{elseif $icon == 'gender-male'}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <circle cx="9.5" cy="14.5" r="4.5"/>
    <path d="M13 11 19 5"/>
    <path d="M15.5 5H19v3.5"/>
  </svg>
{elseif $icon == 'gender-female'}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <circle cx="12" cy="9" r="4.5"/>
    <path d="M12 13.5v7"/>
    <path d="M8.5 17h7"/>
  </svg>
{elseif $icon == 'gender-child'}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <circle cx="12" cy="6" r="2.3"/>
    <path d="M12 8.5v5.5"/>
    <path d="M8.5 10.5h7"/>
    <path d="M12 14 9.5 20"/>
    <path d="m12 14 2.5 6"/>
  </svg>
{elseif $icon == 'gender-mixed'}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <circle cx="8.5" cy="9" r="3"/>
    <circle cx="15.5" cy="9" r="3"/>
    <path d="M5 20c.6-3 2.1-5 4-5"/>
    <path d="M19 20c-.6-3-2.1-5-4-5"/>
    <path d="M9 15c1.8 1.7 4.2 1.7 6 0"/>
  </svg>
{elseif $icon == 'level'}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <path d="M4 20h16"/>
    <path d="M6.5 20v-6"/>
    <path d="M12 20v-9.5"/>
    <path d="M17.5 20V6"/>
    <path d="m15.5 7.5 2-2 2 2"/>
  </svg>
{elseif $icon == 'radius'}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <path d="M5 19c7.7 0 14-6.3 14-14"/>
    <path d="M9 19c5.5 0 10-4.5 10-10"/>
    <path d="M19 5h-4.5"/>
    <path d="M19 5v4.5"/>
    <circle cx="5" cy="19" r="1.6"/>
  </svg>
{elseif $icon == 'program'}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <path d="m3 19 6.5-11 4.2 6.4 2.8-4.4L21 19H3Z"/>
    <path d="m9.5 8 2.1 3.1 1.4-1.7"/>
    <path d="M6.5 19 10 14"/>
  </svg>
{else}
  <svg class="feature-icon-svg" viewBox="0 0 24 24" focusable="false">
    <circle cx="12" cy="12" r="8"/>
    <path d="M12 8v4.5"/>
    <path d="M12 16h.01"/>
  </svg>
{/if}
{/strip}
