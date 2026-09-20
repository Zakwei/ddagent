type DevinLogoProps = {
  className?: string;
};

const DevinLogo = ({ className = 'w-5 h-5' }: DevinLogoProps) => (
  <svg
    viewBox="0 0 24 24"
    role="img"
    aria-label="Devin"
    className={className}
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <rect x="2.5" y="2.5" width="19" height="19" rx="5" className="fill-foreground" />
    <path
      d="M8.5 7.5h4c2.5 0 4.5 2 4.5 4.5s-2 4.5-4.5 4.5h-4v-9z"
      className="stroke-background"
      strokeWidth="2"
      strokeLinejoin="round"
    />
    <circle cx="10" cy="12" r="1.5" className="fill-background" />
  </svg>
);

export default DevinLogo;
