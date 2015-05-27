
//Modified by Jordan Dykstra, Robert Prosser

//#define _USE_MATH_DEFINES
#include <math.h>
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"
#include "xgpio.h"
#include "kiss_fftr.h"
#include "xparameters.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "semphr.h"
#include "xllfifo.h"

#define mainQUEUE_RECEIVE_TASK_PRIORITY		( tskIDLE_PRIORITY + 2 )
#define	mainQUEUE_SEND_TASK_PRIORITY		( tskIDLE_PRIORITY + 1 )
#define mainQUEUE_SEND_FREQUENCY_MS			( 500 / portTICK_PERIOD_MS )
#define UPDATE_TIME_FREQUENCY_MS (2000 / portTICK_PERIOD_MS)
#define mainQUEUE_LENGTH					( 5 )
#define INPUT 1
#define OUTPUT 0
#define FFT_BLOCK_SIZE 1024
#define MAX_DB 200
#define MIN_DB 100

//Interrupt related
#define INTC_DEVICE_ID XPAR_PS7_SCUGIC_0_DEVICE_ID
#define INTC_GPIO0_INT XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR
#define INTC_GPIO1_INT XPAR_FABRIC_AXI_GPIO_1_IP2INTC_IRPT_INTR
#define DATA_INT XGPIO_IR_CH2_MASK

/*
 * The tasks as described in the comments at the top of this file.
 */
static void readADC(void *params);
static void processADCData(void *params);
static void outputData(void *params);
static void WriteToAudioCodec(uint32_t addr, uint32_t data);
static void SetupAudioCodec();
static void CalculateMagnitude();
void leftDataHandler(void *InstancePtr);
void rightDataHandler(void *InstancePtr);
static int IntcInit();
static void acceptLeftData(void *params);
static void Setup(void *params);
static uint32_t ledColor(uint8_t blue, uint8_t red, uint8_t green);
static void ledBars(uint32_t *datas, uint16_t *bars, uint32_t *barColors, uint16_t max);
static void writeLEDs(uint32_t *leds, uint32_t size);
static void four1(double data[], int nn, int isign);

/*-----------------------------------------------------------*/

/* The queue used by both tasks. */
static QueueHandle_t rawDataQueue = NULL;
static QueueHandle_t processedDataQueue = NULL;
static XGpio gpio[6];
static 	int timerValue = 0;
static int timer2Value = 0;
static XScuGic interrupt;
static SemaphoreHandle_t leftDataSem;
static SemaphoreHandle_t rightDataSem;
static XLlFifo XLlFifoDevice;
static double bufferOne[FFT_BLOCK_SIZE];
static double bufferTwo[FFT_BLOCK_SIZE];
static double *readBuffer = bufferOne;
static double *processBuffer = bufferTwo;

/*-----------------------------------------------------------*/

void main_blinky( void )
{
	/* Create the queue. */
	rawDataQueue = xQueueCreate( mainQUEUE_LENGTH, sizeof(int));
	processedDataQueue = xQueueCreate(mainQUEUE_LENGTH, sizeof(double *));
	XGpio_Config *pxConfigPtr;
	BaseType_t xStatus;
	leftDataSem = xSemaphoreCreateBinary();
	rightDataSem = xSemaphoreCreateBinary();
	XLlFifo_Config *pxConfigPtrDevice;

	pxConfigPtrDevice = XLlFfio_LookupConfig(XPAR_AXI_FIFO_MM_S_0_DEVICE_ID);
    xStatus = XLlFifo_CfgInitialize(&XLlFifoDevice, pxConfigPtrDevice, pxConfigPtrDevice->BaseAddress);
	configASSERT(xStatus == XST_SUCCESS);
	XLlFifo_Reset(&XLlFifoDevice);

    /* Initialise the GPIO 0 driver. */
	//Channel 1 -> LDATA_RDY (input from sw perspective)
	//Channel 2 -> LDATA     (input from sw perspective)
	pxConfigPtr = XGpio_LookupConfig( XPAR_AXI_GPIO_0_DEVICE_ID );
	xStatus = XGpio_CfgInitialize( &gpio[0], pxConfigPtr, pxConfigPtr->BaseAddress );
	configASSERT( xStatus == XST_SUCCESS );
	( void ) xStatus;

	/* Initialise the GPIO 1 driver. */
	//Channel 1 -> RDATA_RDY  (input from sw perspective)
	//Channel 2 -> RDATA      (input from sw perspective)
	pxConfigPtr = XGpio_LookupConfig( XPAR_AXI_GPIO_1_DEVICE_ID );
	xStatus = XGpio_CfgInitialize( &gpio[1], pxConfigPtr, pxConfigPtr->BaseAddress );
	configASSERT( xStatus == XST_SUCCESS );
	( void ) xStatus;

	/* Initialise the GPIO 2 driver. */
	//Channel 1 -> LDATA_READ (output from sw perspective)
	//Channel 2 -> RDATA_READ (output from sw perspective)
	pxConfigPtr = XGpio_LookupConfig( XPAR_AXI_GPIO_2_DEVICE_ID );
	xStatus = XGpio_CfgInitialize( &gpio[2], pxConfigPtr, pxConfigPtr->BaseAddress );
	configASSERT( xStatus == XST_SUCCESS );
	( void ) xStatus;

	/* Initialise the GPIO 3 driver. */
	//Channel 1 -> addr (for audio codec) (output from sw perspective)
	//Channel 2 -> data (for audio codec) (output from sw perspective)
	pxConfigPtr = XGpio_LookupConfig( XPAR_AXI_GPIO_3_DEVICE_ID );
	xStatus = XGpio_CfgInitialize( &gpio[3], pxConfigPtr, pxConfigPtr->BaseAddress );
	configASSERT( xStatus == XST_SUCCESS );
	( void ) xStatus;

	/* Initialise the GPIO 4 driver. */
	//Channel 0 -> ready (to process audio codec data) (input from sw perspective)
	//Channel 1 -> data  (reset for audio codec) (input from sw perspective)
	pxConfigPtr = XGpio_LookupConfig( XPAR_AXI_GPIO_4_DEVICE_ID );
	xStatus = XGpio_CfgInitialize( &gpio[4], pxConfigPtr, pxConfigPtr->BaseAddress );
	configASSERT( xStatus == XST_SUCCESS );
	( void ) xStatus;

	/* Initialise the GPIO 4 driver. */
	//Channel 0 -> time 1 (output from sw perspective)
	//Channel 1 -> time 2  (output from sw perspective)
	pxConfigPtr = XGpio_LookupConfig( XPAR_AXI_GPIO_5_DEVICE_ID );
	xStatus = XGpio_CfgInitialize( &gpio[5], pxConfigPtr, pxConfigPtr->BaseAddress );
	configASSERT( xStatus == XST_SUCCESS );
	( void ) xStatus;

	XGpio_SetDataDirection( &gpio[0], 1, INPUT);
	XGpio_SetDataDirection( &gpio[0], 2, INPUT);
	XGpio_SetDataDirection( &gpio[1], 1, INPUT);
	XGpio_SetDataDirection( &gpio[1], 2, INPUT);
	XGpio_SetDataDirection( &gpio[2], 1, OUTPUT);
	XGpio_SetDataDirection( &gpio[2], 2, OUTPUT);
	XGpio_SetDataDirection( &gpio[3], 1, OUTPUT);
	XGpio_SetDataDirection( &gpio[3], 2, OUTPUT);
	XGpio_SetDataDirection( &gpio[4], 1, INPUT);
	XGpio_SetDataDirection( &gpio[4], 2, INPUT);
	XGpio_SetDataDirection( &gpio[5], 1, OUTPUT);
	XGpio_SetDataDirection( &gpio[5], 2, OUTPUT);

	if( rawDataQueue != NULL && processedDataQueue != NULL)
	{
		xTaskCreate( Setup, "setup", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 5, NULL);
		xTaskCreate( acceptLeftData, "left", 65535, NULL, tskIDLE_PRIORITY + 3, NULL);
        xTaskCreate( processADCData, "process", 65535, NULL, tskIDLE_PRIORITY + 1, NULL);
        xTaskCreate( outputData, "output", 65535, NULL, tskIDLE_PRIORITY + 2, NULL);
		vTaskStartScheduler();
	}

	for( ;; );
}

static void Setup(void *params)
{
    BaseType_t xStatus;
	SetupAudioCodec();
	xStatus = IntcInit();
	configASSERT(xStatus == XST_SUCCESS);
	vTaskSuspend(NULL);
}
/*-----------------------------------------------------------*/
static void acceptLeftData(void *params)
{
   //double *cpinl = pvPortMalloc(sizeof(double) * FFT_BLOCK_SIZE);
   double *temp;
   int leftDataCount = 0;
   int32_t leftData = 0;

   for ( ;; )
   {
	   if (xSemaphoreTake(leftDataSem, portMAX_DELAY) == pdTRUE)
	   {
		  leftData = XGpio_DiscreteRead(&gpio[0],2); //read
		  if (leftData & 0x00800000) //negative 24 bit value
			   leftData = leftData | 0xFF000000; //append remaining 1's
		  readBuffer[leftDataCount++] = (double) leftData;

		  //Send data to processing task
		  if (leftDataCount >= FFT_BLOCK_SIZE)
		  {
             temp = processBuffer;
             processBuffer = readBuffer;
             readBuffer = temp;
			 xQueueSend(rawDataQueue, 1, portMAX_DELAY); //pass pointer to data processing task

			 //cpinl = pvPortMalloc(sizeof(double) * FFT_BLOCK_SIZE); //create new array for new data
			 leftDataCount = 0;
		  }
	   }
   }
}

static void processADCData(void *params)
{
	double inData = 0;
	//double *loc1 = NULL;
	//double *loc2 = NULL;
	//kiss_fft_cpx *outData = pvPortMalloc(sizeof(kiss_fft_cpx) * (FFT_BLOCK_SIZE/2 + 1));
	//kiss_fftr_cfg cfg = kiss_fftr_alloc(FFT_BLOCK_SIZE, 0, NULL, NULL);
	//double *data2 = pvPortMalloc((FFT_BLOCK_SIZE*2 + 1 )* sizeof(double));
	double data2[FFT_BLOCK_SIZE*3];
	int i = 0;
    double *magnitude = NULL;
    int good = 0;
    int bad = 0;
    //double temp[32] = {1036.000000000000, -133.0000000000000, -269.0000000000000, 93.00000000000000, 93.00000000000000, -331.0000000000000, -523.0000000000000, -629.0000000000000, 667.0000000000000, -326.0000000000000, -637.0000000000000, -773.0000000000000, 291.0000000000000, -1069.000000000000, 84.00000000000000, -236.0000000000000, -36.00000000000000, -84.00000000000000, 668.0000000000000, 1323.000000000000, -261.0000000000000, 691.0000000000000, -133.0000000000000, -37.00000000000000, -717.0000000000000, 171.0000000000000, -277.0000000000000, -293.0000000000000, -189.0000000000000, -357.0000000000000, 99.00000000000000, -485.0000000000000};

    portTASK_USES_FLOATING_POINT(); //POSITIVELY CRITICAL!

	for ( ;; )
	{
	   xQueueReceive(rawDataQueue, &inData, portMAX_DELAY); //wait for data to process
	   XGpio_DiscreteWrite(&gpio[5], 2, 1);

	   volatile size_t xFreeHeapSpace;
	   xFreeHeapSpace = xPortGetFreeHeapSize();

       /*for (i = 0; i < 32; ++i)
    	   processBuffer[i] = temp[i];*/

	   //Window!
	   /*for (i = 0; i < FFT_BLOCK_SIZE; ++i)
	   {
		   double mult = 0.5 * (1 - cos((2*M_PI*i)/(FFT_BLOCK_SIZE - 1)));
		   inData[i] = mult*(inData[i]);
	   }*/

	   //put data into proper format
	   data2[0] = 0;
	   for (i = 0; i < FFT_BLOCK_SIZE; ++i)
	   {
		   data2[2*i + 1] = processBuffer[i];
		   data2[2*i + 2] = 0;
	   }

	   //FFT
	   four1(data2, FFT_BLOCK_SIZE, 1);

	   //Test block
	   /*four1(data2, FFT_BLOCK_SIZE, -1);

	   //Normalize
	   for (i = 0; i < FFT_BLOCK_SIZE; ++i)
	   {
	      data2[2*i + 1] /= FFT_BLOCK_SIZE;
	      data2[2*i + 2] /= FFT_BLOCK_SIZE;
	   }

	   int good = -1;
	   good = -1;
	   for(i = 0; i < FFT_BLOCK_SIZE; ++i)
	   {
		   double one = data2[2*i + 1];
		   double two = data2[2*i + 2];
		   double three = processBuffer[i];

		   if (one > three + 1)
			   good = i;
		   if (one < three - 1)
			   good = i;
		   if (two > 1)
			   good = i;
		   if (two < -1)
			   good = i;
	   }
       bad = 0;*/

	   magnitude  = pvPortMalloc(FFT_BLOCK_SIZE * sizeof(double));
	   CalculateMagnitude(data2, magnitude, FFT_BLOCK_SIZE); //convert to magnitude for real life
	   XGpio_DiscreteWrite(&gpio[5], 2, 0);
	   xQueueSend(processedDataQueue, &magnitude, portMAX_DELAY); //send to output task
	}
}

#define BASS_RANGE_START  1
#define BASS_RANGE_END    4
#define TWO_RANGE_START   5
#define TWO_RANGE_END     15
#define THREE_RANGE_START 16
#define THREE_RANGE_END   30
#define FOUR_RANGE_START  31
#define FOUR_RANGE_END    60
#define FIVE_RANGE_START  61
#define FIVE_RANGE_END    80
#define SIX_RANGE_START   81
#define SIX_RANGE_END     100
#define SEVEN_RANGE_START 101
#define SEVEN_RANGE_END   110
#define EIGHT_RANGE_START 111
#define EIGHT_RANGE_END   125

uint32_t testDatas[8];
uint32_t data[70];
uint16_t bars[8] = { 0, 0, 0, 0, 0, 0, 0, 0};
uint8_t barsCount[8] = { 0, 0, 0, 0, 0, 0, 0, 0};

static void outputData(void *params)
{
	double *magnitudes = NULL;
    int ind = 0;
    int maxInd = 0;
    int minInd = 0;
    double max = 0;
    int nanPresent = 0;
    int nanCount = 0;
    int goodCount = 0;

	for ( ;; )
	{
		xQueueReceive(processedDataQueue, &magnitudes, portMAX_DELAY);
		//output data to LEDs based on settings
		max = 0;
		maxInd = 0;
		nanPresent = 0;
        for (ind = 1; ind < (FFT_BLOCK_SIZE / 2 - 1); ++ind)
        {
        	if (magnitudes[ind] > max)
        	{
        		max = magnitudes[ind];
        		maxInd = ind;
        	}

        	if (isnan(magnitudes[ind]))
        	{
        	   nanPresent = 1;
        	   nanCount += 1;
        	}
        	else
        	   goodCount += 1;
        }

        if (nanPresent == 0)
        {
				for (ind = 0; ind < 8; ++ind)
					bars[ind] = barsCount[ind] = 0;

				for (ind = 1; ind < (FFT_BLOCK_SIZE / 2 - 1); ++ind)
				{
					if (ind <= BASS_RANGE_END && magnitudes[ind] < max)
					{
						bars[0] += magnitudes[ind];
						++(barsCount[0]);
					}
					else if (ind <= TWO_RANGE_END && magnitudes[ind] < max)
					{
						bars[1] += magnitudes[ind];
						++(barsCount[1]);
					}
					else if (ind <= THREE_RANGE_END && magnitudes[ind] < max)
					{
						bars[2] += magnitudes[ind];
						++(barsCount[2]);
					}
					else if (ind <= FOUR_RANGE_END && magnitudes[ind] < max)
					{
						bars[3] += magnitudes[ind];
						++(barsCount[3]);
					}
					else if (ind <= FIVE_RANGE_END && magnitudes[ind] < max)
					{
						bars[4] += magnitudes[ind];
						++(barsCount[4]);
					}
					else if (ind <= SIX_RANGE_END && magnitudes[ind] < max)
					{
						bars[5] += magnitudes[ind];
						++(barsCount[5]);
					}
					else if (ind <= SEVEN_RANGE_END && magnitudes[ind] < max)
					{
						bars[6] += magnitudes[ind];
						++(barsCount[6]);
					}
					else if (ind <= EIGHT_RANGE_END && magnitudes[ind] < max)
					{
						bars[7] += magnitudes[ind];
						++(barsCount[7]);
					}
				}

				for (ind = 0; ind < 8; ++ind)
					bars[ind] /= barsCount[ind];

				testDatas[0] = ledColor(14, 0, 0);
				testDatas[1] = ledColor(14, 2, 0);
				testDatas[2] = ledColor(14, 4, 0);
				testDatas[3] = ledColor(14, 6, 0);
				testDatas[4] = ledColor(14, 8, 0);
				testDatas[5] = ledColor(14, 10, 0);
				testDatas[6] = ledColor(14, 12, 0);
				testDatas[7] = ledColor(14, 14, 0);

				ledBars(data, bars, testDatas, max < 9 ? 9 : max);

				if (magnitudes[0] != magnitudes[1] && magnitudes[1] != magnitudes[2])
				   writeLEDs(data, 70);
        }

		vPortFree(magnitudes);
	}
}

static void CalculateMagnitude(double *in, double *out, int size)
{
	int ind = 0;

	for (ind = 0; ind < size; ++ind)
	{
		out[ind] = 20*log10(sqrt(in[2*ind+1]*in[2*ind+1] + in[2*ind + 2]*in[2*ind + 2]));
	}
}

//Must be called AFTER drivers are setup
static void SetupAudioCodec()
{
   TickType_t xNextWakeTime = xTaskGetTickCount();
   WriteToAudioCodec(0x0F, 0b000000000); //reset
   vTaskDelayUntil(&xNextWakeTime, 1000 / portTICK_PERIOD_MS);
   WriteToAudioCodec(0x06, 0b000110000); //Power up
   WriteToAudioCodec(0x00, 0b000010111);
   WriteToAudioCodec(0x01, 0b000010111);
   WriteToAudioCodec(0x02, 0b101111001);
   WriteToAudioCodec(0x04, 0b000001010); //Microphone muted
   WriteToAudioCodec(0x05, 0b000000000); //Hypothesis, drive bit 3 high will mute
   WriteToAudioCodec(0x07, 0b000001010);
   WriteToAudioCodec(0x08, 0b000000000);
   vTaskDelayUntil(&xNextWakeTime, 1000 / portTICK_PERIOD_MS); //some cap needs to charge. Refer to datasheet
   WriteToAudioCodec(0x09, 0b000000001);
   WriteToAudioCodec(0x06, 0b000100000);
}

static void WriteToAudioCodec(uint32_t addr, uint32_t data)
{
	TickType_t xNextWakeTime = xTaskGetTickCount();

	//wait for any current writes to the audio codec to complete
	vTaskDelayUntil(&xNextWakeTime, 1000 / portTICK_PERIOD_MS);

	//put in the data and addr
	XGpio_DiscreteWrite(&gpio[3], 1, addr);
	XGpio_DiscreteWrite(&gpio[3], 2, data);

	//Apply a reset in order to write out the data
	XGpio_DiscreteWrite(&gpio[4], 2, 0b1); //reset and hold
	vTaskDelayUntil(&xNextWakeTime, 1 / portTICK_PERIOD_MS);
	XGpio_DiscreteWrite(&gpio[4], 2, 0b0); //drive reset low so the process can start!
}

static int IntcInit()
{
	XScuGic_Config *IntcConfig;
	int status;

	//Initialize interrupt code
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	status = XScuGic_CfgInitialize(&interrupt, IntcConfig, IntcConfig->CpuBaseAddress);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	//Enable the interrupts
	XGpio_InterruptEnable(&gpio[0], 1);

    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
    		(Xil_ExceptionHandler) XScuGic_InterruptHandler, &interrupt);
    Xil_ExceptionEnable();

    //COnnect gpio to respective interrupt handlers
    status = XScuGic_Connect(&interrupt, INTC_GPIO0_INT, (Xil_ExceptionHandler) leftDataHandler, &gpio[0]);
    if (status != XST_SUCCESS)
    	return XST_FAILURE;

     if (status != XST_SUCCESS)
     	return XST_FAILURE;

    //Enable GPIO interrupts
 	 XGpio_InterruptEnable(&gpio[0], 1);
     XGpio_InterruptGlobalEnable(&gpio[0]);

     XScuGic_Enable(&interrupt, INTC_GPIO0_INT);

     return XST_SUCCESS;
}

void leftDataHandler(void *InstancePtr)
{
	BaseType_t xHigherPriorityTaskWoken;
	XGpio_InterruptDisable(&gpio[0], 1);
	//if ((XGpio_InterruptGetStatus(&gpio[0]) & 1) != 1)
		//return;

	xSemaphoreGiveFromISR(leftDataSem, &xHigherPriorityTaskWoken);

	XGpio_InterruptClear(&gpio[0], 1);
	XGpio_InterruptEnable(&gpio[0], 1);
	//XGpio_DiscreteWrite(&gpio[5], 1, 0);
	portYIELD_FROM_ISR(xHigherPriorityTaskWoken);
}

uint32_t ledColor(uint8_t blue, uint8_t red, uint8_t green) {
	uint32_t value = 0x00000000;
	uint8_t tempGreen = 0x00;
	uint8_t tempRed = 0x00;
	uint8_t tempBlue = 0x00;

	int x = 0;
	for (; x < 8; x++) {
		if ((green & (1 << x)) != 0) {
			tempGreen |= 1 << (7 - x);
		}
		if ((red & (1 << x)) != 0) {
			tempRed |= 1 << (7 - x);
		}
		if ((blue & (1 << x)) != 0) {
			tempBlue |= 1<< (7 - x);
		}
	}
	value |= tempGreen;
	value |= tempRed << 8;
	value |= tempBlue << 16;
	return value;
}

void ledBars(uint32_t *datas, uint16_t *bars, uint32_t *barColors, uint16_t max) {
	int pos = 1;
	int x = 0;
	for (; x < 8; x++) {
		int height = bars[x] / (max / 9);
		int y = 0;
		for (; y < height; y++) {
			datas[pos++] = barColors[x];
		}
		for (; y < 8; y++) {
			datas[pos++] = 0;
		}
	}
}

void writeLEDs(uint32_t *leds, uint32_t size) {
    XLlFifo_IntClear(&XLlFifoDevice, XLLF_INT_TC_MASK);
	XLlFifo_Write(&XLlFifoDevice, leds, size*4);
	XLlFifo_TxSetLen(&XLlFifoDevice, size*4);
}

#define PI	M_PI	/* pi to machine precision, defined in math.h */
#define TWOPI	(2.0*PI)

/*
 FFT/IFFT routine. (see pages 507-508 of Numerical Recipes in C)

 Inputs:
	data[] : array of complex* data points of size 2*NFFT+1.
		data[0] is unused,
		* the n'th complex number x(n), for 0 <= n <= length(x)-1, is stored as:
			data[2*n+1] = real(x(n))
			data[2*n+2] = imag(x(n))
		if length(Nx) < NFFT, the remainder of the array must be padded with zeros

	nn : FFT order NFFT. This MUST be a power of 2 and >= length(x).
	isign:  if set to 1,
				computes the forward FFT
			if set to -1,
				computes Inverse FFT - in this case the output values have
				to be manually normalized by multiplying with 1/NFFT.
 Outputs:
	data[] : The FFT or IFFT results are stored in data, overwriting the input.
*/

void four1(double data[], int nn, int isign)
{
    int n, mmax, m, j, istep, i, cat;
    double wtemp, wr, wpr, wpi, wi, theta;
    double tempr, tempi;

    n = nn << 1;
    j = 1;
    for (i = 1; i < n; i += 2) {
	if (j > i) {
	    tempr = data[j];     data[j] = data[i];     data[i] = tempr;
	    tempr = data[j+1]; data[j+1] = data[i+1]; data[i+1] = tempr;
	}
	m = n >> 1;
	while (m >= 2 && j > m) {
	    j -= m;
	    m >>= 1;
	}
	j += m;
    }
    mmax = 2;
    while (n > mmax) {
	istep = 2*mmax;
	theta = TWOPI/(isign*mmax);
	wtemp = sin(0.5*theta);
	wpr = -2.0*wtemp*wtemp;
	wpi = sin(theta);
	wr = 1.0;
	wi = 0.0;
	for (m = 1; m < mmax; m += 2) {
	    for (i = m; i <= n; i += istep) {
		j =i + mmax;
		tempr = wr*data[j]   - wi*data[j+1];
		tempi = wr*data[j+1] + wi*data[j];
		data[j]   = data[i]   - tempr;
		data[j+1] = data[i+1] - tempi;
		data[i] += tempr;
		data[i+1] += tempi;
		if (i > 64 || j > 64)
			cat = 4;
	    }
	    wr = (wtemp = wr)*wpr - wi*wpi + wr;
	    wi = wi*wpr + wtemp*wpi + wi;
	}
	mmax = istep;
    }
}

