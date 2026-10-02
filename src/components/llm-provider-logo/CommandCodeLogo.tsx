type CommandCodeLogoProps = {
  className?: string;
};

const CommandCodeLogo = ({ className = 'w-5 h-5' }: CommandCodeLogoProps) => (
  <svg
    viewBox="0 0 24 24"
    role="img"
    aria-label="Command Code"
    className={className}
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <rect x="2.5" y="2.5" width="19" height="19" rx="4" className="fill-foreground" />
    <path
      d="M7 9.5 10.5 12 7 14.5M12 15.5h5"
      className="stroke-background"
      strokeWidth="1.9"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
);

export default CommandCodeLogo;
