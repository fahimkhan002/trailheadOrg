import { LightningElement, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import CHART_JS from '@salesforce/resourceUrl/ChartJs';

export default class TaxCalculator extends LightningElement {
    @track monthlySalary = 0;
    @track selectedTaxYear = '2023'; // Default tax year
    @track monthlyIncome = 0;
    @track monthlyTax = 0;
    @track salaryAfterTax = 0;
    @track yearlyIncome = 0;
    @track yearlyTax = 0;
    @track yearlyIncomeAfterTax = 0;
    @track monthlyTaxPercentage = 0;
    @track monthlyIncomePercentage = 0;

    taxYears = [
        
        { label: '2023', value: '2023' },
        { label: '2022', value: '2022' },
        {label: '2021', value: '2021'}
        // Add more tax years as needed
    ];

    handleMonthlySalaryChange(event) {
        this.monthlySalary = parseFloat(event.target.value);
        this.calculateTax();
    }

    handleTaxYearChange(event) {
        this.selectedTaxYear = event.detail.value;
        this.calculateTax();
    }

    // get monthlyTaxPercentageClass() {
    //     return this.monthlyTaxPercentage >= 0 ? 'tax-percentage-red' : 'tax-percentage-green';
    // }
    
    // get monthlyIncomePercentageClass() {
    //     return this.monthlyIncomePercentage >= 0 ? 'tax-percentage-green' : 'tax-percentage-red';
    // }
    

    calculateTax() {
        const monthlySalary = this.monthlySalary;
        const yearlySalary = monthlySalary * 12;
        let taxAmount = 0;

        if (yearlySalary <= 600000) {
            // Tax rate is 0% for income up to Rs. 600,000
            taxAmount = 0;
        } else if (yearlySalary <= 1200000) {
            // Tax rate is 2.5% of the amount exceeding Rs. 600,000
            taxAmount = (yearlySalary - 600000) * 0.025;
        } else if (yearlySalary <= 2400000) {
            // Tax rate is Rs. 15,000 plus 12.5% of the amount exceeding Rs. 1,200,000
            taxAmount = 15000 + (yearlySalary - 1200000) * 0.125;
        } else if (yearlySalary <= 3600000) {
            // Tax rate is Rs. 165,000 plus 22.5% of the amount exceeding Rs. 2,400,000
            taxAmount = 165000 + (yearlySalary - 2400000) * 0.225;
        } else if (yearlySalary <= 6000000) {
            // Tax rate is Rs. 435,000 plus 27.5% of the amount exceeding Rs. 3,600,000
            taxAmount = 435000 + (yearlySalary - 3600000) * 0.275;
        } else {
            // Tax rate is Rs. 1,095,000 plus 35% of the amount exceeding Rs. 6,000,000
            taxAmount = 1095000 + (yearlySalary - 6000000) * 0.35;
        }

        this.monthlyIncome = monthlySalary;
        this.monthlyTax = taxAmount / 12; // Divide by 12 for monthly tax
        this.salaryAfterTax = monthlySalary - this.monthlyTax;
        this.yearlyIncome = yearlySalary;
        this.yearlyTax = taxAmount;
        this.yearlyIncomeAfterTax = yearlySalary - taxAmount;

        // Calculate Monthly Tax Percentage
        this.monthlyTaxPercentage = ((this.monthlyTax / this.monthlySalary) * 100).toFixed(1);

        // Calculate Monthly Income Percentage
        this.monthlyIncomePercentage = (100 - this.monthlyTaxPercentage).toFixed(1);
    }


    chart;

    async renderedCallback() {
        await this.loadChartJs();
        
        const canvas = this.template.querySelector('canvas.donutChart');

        if (canvas) {
            if (this.chart) {
                this.chart.destroy();
            }
            this.initializeChart(canvas);
        }
    }
    

    async loadChartJs() {
        if (typeof Chart === 'undefined') {
            await loadScript(this, CHART_JS);
        }
    }

    async initializeChart(canvas) {
        const ctx = canvas.getContext('2d');
    
        this.chart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Tax', 'Income'],
                datasets: [{
                    data: [this.monthlyTaxPercentage, this.monthlyIncomePercentage],
                    backgroundColor: ['red', 'green']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    }
    





}
