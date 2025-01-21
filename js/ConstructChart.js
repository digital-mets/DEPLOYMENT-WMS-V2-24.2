
async function ConstCHART(series, height, dropshadow) {

    options = {
        series: series,
        markers: {
            size: 5,

        },
        //xaxis: {
        //    categories:,
        //},
        chart: {
            type: 'bar',
            height: height,

            toolbar: {
                show: true,
                offsetX: 0,
                offsetY: 0,
                tools: {
                    download: true,
                    selection: true,
                    zoom: true,
                    zoomin: true,
                    zoomout: true,
                    pan: true,
                    reset: true | '<img src="/static/icons/reset.png" width="20">',
                    customIcons: []
                },
                export: {
                    csv: {
                        filename: 'export',
                        headerCategory: 'category',
                        headerValue: 'value',
                    },
                    svg: {
                        filename: 'export',
                    },
                    png: {
                        filename: 'export',
                    }
                },
                autoSelected: 'zoom'

            },
            dropShadow: {
                enabled: dropshadow,
                top: 0,
                left: 0,
                blur: 3,
                opacity: 0.5
            },


        },
        plotOptions: {
            bar: {
                borderRadius: 10,
                dataLabels: {
                    position: 'top', // top, center, bottom
                },
            }
        },
        dataLabels: {
            enabled: true,
            style: {
                colors: ['#333']
            },
            offsetY: -20,

            background: {
                enabled: false,

            },
        },
        stroke: {
            width: [2, 2, 2],
        },
        noData: {
            text: 'No data'
        },
        yaxis: {
            title: {
                text: 'Transactions Count'
            }
        },
    };


}



